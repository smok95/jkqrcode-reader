package com.smok95.jkqrcode;

import android.content.Context;
import android.hardware.Camera;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Toast;
import me.dm7.barcodescanner.core.IViewFinder;
import me.dm7.barcodescanner.core.ViewFinderView;
import me.dm7.barcodescanner.zbar.Result;
import me.dm7.barcodescanner.zbar.ZBarScannerView;

/**
 * A placeholder fragment containing a simple view.
 */
public class MainActivityFragment extends Fragment implements ZBarScannerView.ResultHandler, ScanResultFragment.OnScanResultListener {
    private ZBarScannerView mScanView;
    private boolean mShownResultDialog = false; // 스캔결과팝업 표시 여부
    private boolean mClosedCamera = true;      // 카메라종료 여부
    public MainActivityFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        mScanView = new ZBarScannerView(getActivity()){
            @Override
            protected IViewFinder createViewFinderView(Context ctx){
                return new CustomViewFinderView(ctx);
            }

            @Override
            public void onPreviewFrame(byte[] data, Camera camera){
                camera.getParameters().setPreviewSize(100,100);
                super.onPreviewFrame(data, camera);
            }
        };

        // 화면꺼짐 방지
        getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        return mScanView;
        //return inflater.inflate(R.layout.fragment_main, container, false);
    }

    @Override
    public void handleResult(Result result) {

       // Toast.makeText(getActivity(), "Contents=" + result.getContents() + "Format = " + result.getBarcodeFormat().getName(), Toast.LENGTH_LONG).show();
        FragmentManager fm = getActivity().getSupportFragmentManager();
        ScanResultFragment popup = ScanResultFragment.newInstance(this, result.getBarcodeFormat().getName(), result.getContents());
        popup.show(fm, "ScanResultFragment");
        mShownResultDialog = true;

        /*
        // Note:
        // * Wait 2 seconds to resume the preview.
        // * On older devices continuously stopping and resuming camera preview can result in freezing the app.
        // * I don't know why this is the case but I don't have the time to figure out.
        Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                mScanView.resumeCameraPreview(MainActivityFragment.this);
            }
        }, 2000);
        */
    }

    @Override
    public void onResume(){
        super.onResume();
        if(!mShownResultDialog)
        {
            //Toast.makeText(getActivity(), "onResume() call, startCamera.", Toast.LENGTH_SHORT).show();
            mScanView.setResultHandler(this);
            mScanView.startCamera();
            mClosedCamera = false;
        }
    }

    @Override
    public void onPause(){
        super.onPause();
        mScanView.stopCamera();
        mClosedCamera = true;
    }

    @Override
    public void onClose(ScanResultFragment sender) {
        mShownResultDialog = false;
        // 팝업화면 닫히면 다시 스캔시작
        if(mClosedCamera) {
            mScanView.setResultHandler(this);
            mScanView.startCamera();
        }
        else
            mScanView.resumeCameraPreview(MainActivityFragment.this);
    }


    private static class CustomViewFinderView extends ViewFinderView{
        public CustomViewFinderView(Context ctx){
            super(ctx);
            // Set square viewfinder
            setSquareViewFinder(true);
            setBorderColor(ContextCompat.getColor(ctx,R.color.colorScanBorder));
            setLaserColor(ContextCompat.getColor(ctx, R.color.colorScanLaser));
            setBorderLineLength(100);
        }
    }
}
