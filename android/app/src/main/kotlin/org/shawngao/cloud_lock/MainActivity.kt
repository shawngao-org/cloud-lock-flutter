package org.shawngao.cloud_lock

import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import org.shawngao.cloud_lock.plugin.ToastProvider

class MainActivity: FlutterActivity() {

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        val permissions = arrayOf(android.Manifest.permission.POST_NOTIFICATIONS,
            android.Manifest.permission.RECEIVE_WAP_PUSH,
            android.Manifest.permission.VIBRATE,
            android.Manifest.permission.RECEIVE_BOOT_COMPLETED,
            android.Manifest.permission.INTERNET,
            android.Manifest.permission.WAKE_LOCK,
            android.Manifest.permission.ACCESS_NOTIFICATION_POLICY,
            android.Manifest.permission.BROADCAST_STICKY
        )
        val unGrantPermissions = mutableListOf<String>()
        permissions.forEach { item ->
            if (ContextCompat.checkSelfPermission(this, item)
                != PackageManager.PERMISSION_GRANTED) {
                unGrantPermissions.add(item)
            }
        }
        if (unGrantPermissions.size > 0) {
            ActivityCompat.requestPermissions(this, unGrantPermissions.toTypedArray(),
                1)
        }
        super.configureFlutterEngine(flutterEngine)
        ToastProvider.register(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        val homeIntent = Intent(Intent.ACTION_MAIN)
        homeIntent.addCategory(Intent.CATEGORY_HOME)
        homeIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(homeIntent)
    }
}
