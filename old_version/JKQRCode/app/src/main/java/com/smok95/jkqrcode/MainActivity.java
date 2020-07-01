package com.smok95.jkqrcode;

import android.*;
import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.FragmentManager;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.MobileAds;

public class MainActivity extends AppCompatActivity {
    private AdView mAdView;
    static final int REQUEST_PERMISSION = 1000;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Initialize the Mobile Ads SDK.
        MobileAds.initialize(this, "ca-app-pub-0843163070431190~2987241062");

        mAdView = (AdView)findViewById(R.id.ad_view);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        // Create and ad request. Check your logcat output for the hashed device ID to
        // get test ads on a physical device. e.g.
        // "Use AdRequest.Builder.addTestDevice("ABCDEF012345") to get test ads on this device."
        AdRequest adRequest = new AdRequest.Builder()
                .addTestDevice(AdRequest.DEVICE_ID_EMULATOR).build();

        // 권한 체크
        String[] reqPms = Util.checkRequiredPermissions(this, new String[]{Manifest.permission.CAMERA});
        if(reqPms.length > 0)
            ActivityCompat.requestPermissions(this, reqPms, REQUEST_PERMISSION);

        // Start loading the ad in the background.
        mAdView.loadAd(adRequest);
    }

    @Override
    public void onRequestPermissionsResult(int reqCode, String[] permissions, int[] grantResults){
        if(reqCode != REQUEST_PERMISSION) return;

        boolean isDenied = false;
        // 권한 획득 실패시 프로그램 종료
        for (int ret:grantResults) {
            if(ret == PackageManager.PERMISSION_DENIED){
                isDenied = true;
                break;
            }
        }

        if(isDenied)
            Util.exitWithMsgBox(this, "Permission error", "Permission has not been granted.", "OK");
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if(id == R.id.action_exit){
            finish();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onPause(){
        mAdView.pause();
        super.onPause();
    }

    @Override
    public void onResume(){
        mAdView.resume();
        super.onResume();
    }

    @Override
    public void onDestroy(){
        mAdView.destroy();
        super.onDestroy();
    }
}
