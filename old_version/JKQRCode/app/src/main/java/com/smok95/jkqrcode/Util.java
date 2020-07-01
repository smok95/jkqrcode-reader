package com.smok95.jkqrcode;
/*
    20161004 checkRequiredPermissions 추가
 */
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.telephony.TelephonyManager;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by smok95 on 3/25/15.
 */
public class Util {

    /**
     * 현재 기기의 전화번호 가져오
     * @param ctx
     * @return
     */
    static public String getPhoneNumber(Context ctx) {
        TelephonyManager tMgr = (TelephonyManager) ctx.getApplicationContext().getSystemService(Context.TELEPHONY_SERVICE);
        return tMgr.getLine1Number();
    }

    /**
     * 네트워크 연결상태 확
     * @param ctx
     * @return
     */
    static public boolean isNetworkConnected(Context ctx)
    {
        ConnectivityManager cm =(ConnectivityManager)ctx.getApplicationContext().getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo ni = cm.getActiveNetworkInfo();
        return (ni!=null && ni.isConnected());
    }

    /**
     * email 유효성 검증
     * @param target
     * @return 유효한 이메일 주소이면 true
     */
    public final static boolean isValidEmail(CharSequence target) {
        if (target == null) return false;
        return android.util.Patterns.EMAIL_ADDRESS.matcher(target).matches();
    }


    /**
     * 앱을 종료한다.
     * @param activity 메인엑티비
     */
    public final static void exitApp(Activity activity)
    {
        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_HOME);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        activity.startActivity(intent);
        activity.finish();
    }

    /**
     * 메시지박스 표시후 앱 종료
     * @param activity
     * @param title
     * @param message
     * @param okBtnText
     */
    public final static void exitWithMsgBox(Activity activity, String title, String message, String okBtnText)
    {
        final Activity thisActivity = activity;
        AlertDialog.Builder dlg = new AlertDialog.Builder(activity);
        dlg.setMessage(message);
        dlg.setTitle(title);
        dlg.setPositiveButton(okBtnText, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                // 앱 종료
                Util.exitApp(thisActivity);
            }
        });
        dlg.setCancelable(false);
        dlg.create().show();
    }

    /**
     * 메시지박스 표시
     * @param activity
     * @param title
     * @param message
     * @param okBtnText
     */
    public final static void msgBox(Activity activity, String title, String message, String okBtnText)
    {
        final Activity thisActivity = activity;
        AlertDialog.Builder dlg = new AlertDialog.Builder(activity);
        dlg.setMessage(message);
        dlg.setTitle(title);
        dlg.setPositiveButton(okBtnText, null);
        dlg.create().show();
    }


    /**
     * Runtime Permission Check 권한획득 필요여부 확인
     * @param permissions 확인할 권한 목록
     * @return 획득해야할 권한 목록
     */
    public final static String[] checkRequiredPermissions(Context ctx, String[] permissions)
    {
        List<String> results = new ArrayList<String>();

        // Marshmallow 하위버전이면 필요없음.
        if(Build.VERSION.SDK_INT < Build.VERSION_CODES.M)
            return results.toArray(new String[0]);

        // 권한획득이 필요한 항목만 리턴값에 추가
        for (String permission:permissions) {
            int ret = ContextCompat.checkSelfPermission(ctx, permission);
            if(ret == PackageManager.PERMISSION_DENIED)
                results.add(permission);
        }
        return results.toArray(new String[0]);
    }
}
