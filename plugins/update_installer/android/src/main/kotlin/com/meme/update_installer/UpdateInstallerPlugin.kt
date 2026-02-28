package com.meme.update_installer

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class UpdateInstallerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    context = binding.applicationContext
    channel = MethodChannel(binding.binaryMessenger, "com.meme.melotrip/update")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "canRequestPackageInstalls" -> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
          result.success(true)
        } else {
          result.success(context.packageManager.canRequestPackageInstalls())
        }
      }

      "openUnknownSourcesSettings" -> {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
          val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES).apply {
            data = Uri.parse("package:${context.packageName}")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
          }
          context.startActivity(intent)
        }
        result.success(null)
      }

      "installApk" -> {
        val filePath = call.argument<String>("filePath")
        if (filePath.isNullOrBlank()) {
          result.error("INVALID_ARGUMENT", "filePath is required", null)
          return
        }
        installApk(filePath, result)
      }

      else -> result.notImplemented()
    }
  }

  private fun installApk(filePath: String, result: MethodChannel.Result) {
    try {
      val apkFile = File(filePath)
      if (!apkFile.exists()) {
        result.error("FILE_NOT_FOUND", "APK file does not exist: $filePath", null)
        return
      }

      val authority = "${context.packageName}.fileprovider"
      val apkUri = FileProvider.getUriForFile(context, authority, apkFile)
      val installIntent = Intent(Intent.ACTION_VIEW).apply {
        setDataAndType(apkUri, "application/vnd.android.package-archive")
        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
      }
      context.startActivity(installIntent)
      result.success(null)
    } catch (err: Exception) {
      result.error("INSTALL_APK_FAILED", err.message, null)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

