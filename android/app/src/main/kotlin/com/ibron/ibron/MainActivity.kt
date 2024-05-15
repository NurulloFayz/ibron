package com.ibron.ibron

//import android.app.Application

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity(){
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine){
        MapKitFactory.setApiKey("5a634596-1169-4faf-8e29-1dbbb9562526")
        super.configureFlutterEngine(flutterEngine)
    }
}

