package org.shawngao.cloud_lock.service

import android.app.Service
import android.content.Intent
import android.os.IBinder

class MainService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    override fun onBind(p0: Intent?): IBinder? {
        TODO("Not yet implemented")
    }
}
