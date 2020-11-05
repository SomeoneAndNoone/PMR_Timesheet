package com.hamidovhamid.pmr_staff

import android.content.ContentResolver
import android.content.Context
import android.media.RingtoneManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

//import android.content.ContentResolver
//import android.content.Context
//import android.media.RingtoneManager
import android.os.Bundle
import java.util.TimeZone
//import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
//import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.getDartExecutor(), "dexterx.dev/flutter_local_notifications_example").setMethodCallHandler { call, result ->
            if ("drawableToUri" == call.method) {
                val resourceId: Int = this@MainActivity.getResources().getIdentifier(call.arguments as String, "drawable", this@MainActivity.getPackageName())
                result.success(resourceToUriString(this@MainActivity.getApplicationContext(), resourceId))
            }
            if ("getAlarmUri" == call.method) {
                result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM).toString())
            }
            if ("getTimeZoneName" == call.method) {
                result.success(TimeZone.getDefault().id)
            }
        }
    }

    companion object {
        private fun resourceToUriString(context: Context, resId: Int): String {
            return (ContentResolver.SCHEME_ANDROID_RESOURCE
                    + "://"
                    + context.resources.getResourcePackageName(resId)
                    + "/"
                    + context.resources.getResourceTypeName(resId)
                    + "/"
                    + context.resources.getResourceEntryName(resId))
        }
    }
}
