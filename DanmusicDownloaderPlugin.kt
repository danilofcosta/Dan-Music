package com.example.danmusic_downloader

import androidx.lifecycle.lifecycleScope
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.github.shalva97.initNewPipe
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.schabi.newpipe.extractor.ServiceList

class DanmusicDownloaderPlugin: FlutterPlugin, MethodChannel.MethodCallHandler {

    private lateinit var channel : MethodChannel
    private val service = ServiceList.YouTube

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.example.danmusic_downloader/downloader")
        channel.setMethodCallHandler(this)

        // Inicializa NewPipe
        initNewPipe()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getVideoUrl" -> {
                val videoId = call.argument<String>("videoId") ?: ""
                // Rodar em background
                GlobalScope.launch(Dispatchers.IO) {
                    val url = getVideoUrl(videoId)
                    withContext(Dispatchers.Main) {
                        if (url != null) result.success(url)
                        else result.error("ERROR", "Não foi possível obter a URL do vídeo", null)
                    }
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun getVideoUrl(videoId: String): String? {
        return try {
            val extractor = service.getStreamExtractor("https://www.youtube.com/watch?v=$videoId")
            extractor.audioStreams.firstOrNull()?.url
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
