package io.agora.rte.extensions.widget.im

import android.content.Context
import android.text.TextUtils
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.ViewGroup.MarginLayoutParams
import android.widget.FrameLayout
import android.widget.RelativeLayout
import androidx.appcompat.widget.AppCompatTextView
import androidx.core.view.isVisible
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.google.gson.Gson
import com.hyphenate.chat.EMMessage
import com.hyphenate.easeim.modules.EaseIM
import com.hyphenate.easeim.modules.constant.EaseConstant.ROLE_STUDENT
import com.hyphenate.easeim.modules.manager.ThreadManager
import com.hyphenate.easeim.modules.repositories.EaseRepository
import com.hyphenate.easeim.modules.utils.CommonUtil
import com.hyphenate.easeim.modules.utils.SoftInputUtil
import com.hyphenate.easeim.modules.view.`interface`.ChatPagerListener
import com.hyphenate.easeim.modules.view.`interface`.InputMsgListener
import com.hyphenate.easeim.modules.view.ui.widget.ChatViewPager
import com.hyphenate.easeim.modules.view.ui.widget.InputView
import com.hyphenate.easeim.modules.view.ui.widget.ShowImageView
import io.agora.agoraeduuikit.component.toast.AgoraUIToast
import io.agora.agoraeduuikit.impl.chat.AgoraChatInteractionPacket
import io.agora.agoraeduuikit.impl.chat.AgoraChatInteractionSignal

class RCTAgoraChatViewManager : SimpleViewManager<View>(), InputMsgListener, ChatPagerListener {
    private val LOG_TAG = "RCTAgoraChatViewManager";

    private var layout: View? = null
    private var mContext: Context? = null
    private var orgName = ""
    private var appName = ""
    private var appKey = ""
    private var role = ROLE_STUDENT
    private var userName = ""
    private var userUuid = ""
    private var mChatRoomId = ""
    private var nickName = ""
    private var avatarUrl = "https://download-sdk.oss-cn-beijing.aliyuncs.com/downloads/IMDemo/avatar/Image1.png"
    private var roomUuid = ""
    private var chatViewPager: ChatViewPager? = null
    private var contentLayout: FrameLayout? = null
    private var inputView: InputView? = null

    // specified input`s parentView
    private var specialInputViewParent: ViewGroup? = null
    private var showImageView: ShowImageView? = null
    private val softInputUtil = SoftInputUtil()

    // Specially designed to avoid recycler view having a minus height
    private val elevation = 0
    private lateinit var hideLayout: RelativeLayout
    private lateinit var unreadText: AppCompatTextView
    private var initLoginEaseIM = false

    var isNeedRoomMutedStatus = true // 是否需要判断禁言状态

    override fun getName(): String {
        return REACT_CLASS
    }

    public override fun createViewInstance(reactContext: ThemedReactContext): View {
        mContext = reactContext
        layout = initContainerUIwithChattingAndNoticing(mContext!!) // or initContainerUIwithChattingAndNoticing(mContext)/contentLayout;
        addEaseIM(mContext!!) // contentLayout or null
        return layout!! // MarginLayoutParams.MATCH_PARENT
    }

    private fun getInputViewParent(): ViewGroup? {
        return specialInputViewParent
    }

    private fun initContainerUIwithChattingAndNoticing(context: Context): View {
        LayoutInflater.from(context).inflate(R.layout.ease_chat_layout, null, false)?.let {
            layout = it
            contentLayout = it.findViewById(R.id.fragment_container)
            contentLayout?.clipToOutline = true
            contentLayout?.elevation = elevation.toFloat()

            hideLayout = it.findViewById(R.id.chat_hide_icon_layout)
            unreadText = it.findViewById(R.id.chat_unread_text)
            hideLayout.visibility = View.GONE
        }

        chatViewPager = ChatViewPager(context)

        contentLayout?.removeAllViews()
        contentLayout?.addView(chatViewPager)

        return layout!!
    }

    private fun initOnlyChattingView(context: Context): View {
        return View(context)
    }

    private fun addEaseIM(context: Context) {
        if (!parseEaseConfigProperties()) {
            return
        }

        if (initLoginEaseIM) {
            return
        }

        // TODO(Hai_Guo) check if we can hide tab container and titles and only left chatting ui
        chatViewPager?.let {
            it.setAvatarUrl(avatarUrl)
            it.setChatRoomId(mChatRoomId)
            it.setNickName(nickName)
            it.setRoomUuid(roomUuid)
            it.setUserName(userName)
            it.setUserUuid(userUuid)
        }

        chatViewPager?.chatPagerListener = this

        if (appKey.isNotEmpty() && EaseIM.getInstance().init(mContext, appKey)) {
            EaseRepository.instance.isInit = true
            chatViewPager?.loginIM()
        } else {
            mContext?.let {
                AgoraUIToast.error(
                    context = it.applicationContext, text = mContext?.getString(
                        R.string.fcr_login_chat_failed
                    ) + "--" +
                            mContext?.getString(R.string.fcr_appKey_is_empty)
                )
            }
        }

        mContext?.let {
            inputView = InputView(it)
            val params = RelativeLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            params.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM)
            val inputParent = getInputViewParent() ?: layout?.parent // find the proper parent view
            inputView?.let { input ->
                input.layoutParams = params
                if (inputParent != null && inputParent is ViewGroup) {
                    inputParent.addView(input)
                    input.visibility = View.GONE
                    input.inputMsgListener = this
                    softInputUtil.attachSoftInput(input) { isSoftInputShow, softInputHeight, viewOffset ->
                        if (isSoftInputShow)
                            input.translationY = input.translationY - viewOffset
                        else {
                            input.translationY = 0F
                            if (input.isNormalFace()) input.visibility = View.GONE
                        }
                    }
                }
            }
            showImageView = ShowImageView(it)
            showImageView?.let { image ->
                val params = RelativeLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT)
                image.layoutParams = params
                if (inputParent != null && inputParent is ViewGroup) {
                    inputParent.addView(image)
                    image.chatPagerListener = this
                    image.visibility = View.GONE
                    image.setOnClickListener {
                        image.visibility = View.GONE
                    }
                }
            }
        }

        initLoginEaseIM = true
    }

    private fun parseEaseConfigProperties(): Boolean {
//        appKey = "1129210531094378#apaas-edu"
//        mChatRoomId = "186347325292547"
//        nickName = "ssssssssxx"
//        roomUuid = "mmmmm1234560"
//        userName = "c843a2f5f2edae111a15e80c8875f93a"
//        userUuid = "c843a2f5f2edae111a15e80c8875f93a"
//        val password = userUuid

        android.util.Log.d(LOG_TAG, "parseEaseConfigProperties $userName $userUuid $nickName $mChatRoomId $roomUuid")

        return (!TextUtils.isEmpty(userName)
                && !TextUtils.isEmpty(userUuid)
//                && !TextUtils.isEmpty(orgName)
//                && !TextUtils.isEmpty(appName)
                && !TextUtils.isEmpty(mChatRoomId)
                && !TextUtils.isEmpty(appKey))
    }

    @ReactProp(name = "chatInfo")
    public fun setChatInfo(imRootView: View, chatInfo: ReadableMap) {
        nickName = chatInfo.getString("nickName")!!
        userName = chatInfo.getString("userName")!!
        userUuid = chatInfo.getString("userName")!!
        orgName = chatInfo.getString("orgName") ?: ""
        appName = chatInfo.getString("appName") ?: ""
        roomUuid = chatInfo.getString("roomUuid")!!
        mChatRoomId = chatInfo.getString("chatRoomId")!!
        appKey = chatInfo.getString("appKey")!!
        role = ROLE_STUDENT
        val password = userUuid
        EaseRepository.instance.role = role

        android.util.Log.d(LOG_TAG,
            "setChatInfo $userName $userUuid $nickName, $mChatRoomId, $appKey $roomUuid $role"
        )

        addEaseIM(imRootView.context)
    }

    companion object {
        const val REACT_CLASS = "RCTRteChatView"
    }

    // 匹配与 messageObserver
    protected fun sendMessage(message: String) {
    }

    override fun onSendMsg(content: String) {
        chatViewPager?.sendTextMessage(content)
        inputView?.visibility = View.GONE
    }

    override fun onOutsideClick() {
        inputView?.visibility = View.GONE
    }

    override fun onContentChange(content: String) {
        chatViewPager?.setInputContent(content)
    }

    override fun onSelectImage() {
        chatViewPager?.selectPicFromLocal()
        inputView?.visibility = View.GONE
    }

    override fun onImageClick(message: EMMessage) {
        showImageView?.loadImage(message)
        showImageView?.visibility = View.VISIBLE
    }

    override fun onCloseImage() {
        showImageView?.visibility = View.GONE
    }

    override fun onMsgContentClick() {
        inputView?.visibility = View.VISIBLE
        inputView?.hideFaceView()
    }

    override fun onFaceIconClick() {
        inputView?.visibility = View.VISIBLE
        inputView?.showFaceView()
    }

    override fun onMuted(isMuted: Boolean) {
        if (isMuted && inputView?.isVisible == true) {
            inputView?.editContent?.let { CommonUtil.hideSoftKeyboard(it) }
            inputView?.visibility = View.GONE
        }
    }

    override fun onIconHideenClick() {
        dismiss()
    }

    override fun onShowUnread(show: Boolean) {
        ThreadManager.instance.runOnMainThread {
            if (hideLayout.isVisible)
                unreadText.visibility = View.VISIBLE
            else
                unreadText.visibility = if (show) View.VISIBLE else View.GONE
        }
        broadcasterUnreadTip(show)
        // 收到消息一直是 false
//        chatWidgetListener?.onShowUnread(show)
    }

    private fun broadcasterUnreadTip(show: Boolean) {
        val body = AgoraChatInteractionPacket(AgoraChatInteractionSignal.UnreadTips, show)
        sendMessage(Gson().toJson(body))
    }

    /**
     * Ease chat sdk logout and release all data and
     * resources of chat engine if the view is detached
     * from window. Here we set the size of window to
     * zero to dismiss chat widget layout
     */
    fun dismiss() {
        layout?.let { layout ->
            val param = layout.layoutParams as MarginLayoutParams
            param.width = 0
            param.height = 0
            layout.layoutParams = param
        }
    }
}
