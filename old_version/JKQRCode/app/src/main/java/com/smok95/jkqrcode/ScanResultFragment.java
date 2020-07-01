package com.smok95.jkqrcode;

import android.app.SearchManager;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.support.v4.view.WindowCompat;
import android.util.Patterns;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import org.w3c.dom.Text;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link OnScanResultListener} interface
 * to handle interaction events.
 * Use the {@link ScanResultFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class ScanResultFragment extends DialogFragment implements View.OnClickListener {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "barcode_format";
    private static final String ARG_PARAM2 = "contents";

    private TextView mTvFormatName = null;
    private TextView mTvContents = null;

    // TODO: Rename and change types of parameters
    private String mFormatName;
    private String mContents;

    private OnScanResultListener mListener;
    private Button mBtnCopy, mBtnShare, mBtnSearch, mBtnClose, mBtnWeb;

    public ScanResultFragment() {
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment ScanResultFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static ScanResultFragment newInstance(OnScanResultListener listener, String barcodeFormat, String contents) {
        ScanResultFragment fragment = new ScanResultFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, barcodeFormat);
        args.putString(ARG_PARAM2, contents);
        fragment.setArguments(args);
        fragment.setListener(listener);
        return fragment;
    }

    private void setListener(OnScanResultListener listener){
        mListener = listener;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mFormatName = getArguments().getString(ARG_PARAM1);
            mContents = getArguments().getString(ARG_PARAM2);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        // 타이틀바 속성 제거
        getDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);
        View view = inflater.inflate(R.layout.fragment_scan_result, container, false);

        mTvFormatName = (TextView)view.findViewById(R.id.tvFormat);
        mTvContents  = (TextView)view.findViewById(R.id.tvContents);
        mBtnCopy = (Button)view.findViewById(R.id.btnCopy);
        mBtnShare = (Button)view.findViewById(R.id.btnShare);
        mBtnSearch = (Button)view.findViewById(R.id.btnSearch);
        mBtnClose = (Button)view.findViewById(R.id.btnClose);
        mBtnWeb = (Button)view.findViewById(R.id.btnWeb);
        mBtnCopy.setOnClickListener(this);
        mBtnShare.setOnClickListener(this);
        mBtnSearch.setOnClickListener(this);
        mBtnClose.setOnClickListener(this);
        mBtnWeb.setOnClickListener(this);

        mTvFormatName.setText(mFormatName);
        mTvContents.setText(mContents);

        // 데이터가 url인 경우에만 웹버튼 표시
        if(Patterns.WEB_URL.matcher(mContents).matches())
            mBtnWeb.setVisibility(View.VISIBLE);
        else
            mBtnWeb.setVisibility(View.INVISIBLE);
        return view;
    }

    public void onClick(View v){
        switch (v.getId()){
            case R.id.btnClose:
                this.dismiss();
                break;
            case R.id.btnCopy: // Copy text to clipboard
                ClipboardManager clipboard = (ClipboardManager)getContext().getSystemService(Context.CLIPBOARD_SERVICE);
                ClipData clip = ClipData.newPlainText(mFormatName, mContents);
                clipboard.setPrimaryClip(clip);
                Toast.makeText(getContext(), getString(R.string.copy_to_clipboard), Toast.LENGTH_SHORT).show();
                break;
            case R.id.btnSearch:
                Intent intent = new Intent(Intent.ACTION_WEB_SEARCH);
                intent.putExtra(SearchManager.QUERY, mContents);
                startActivity(intent);
                break;
            case R.id.btnShare:
                Intent sendIntent = new Intent();
                sendIntent.setAction(Intent.ACTION_SEND);
                sendIntent.putExtra(Intent.EXTRA_TEXT, mContents);
                sendIntent.setType("text/plain");
                startActivity(sendIntent);
                break;
            case R.id.btnWeb:
                Intent i = new Intent(Intent.ACTION_VIEW);
                i.setData(Uri.parse(mContents));
                startActivity(i);
                break;
        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
    }

    @Override
    public void onDetach() {
        super.onDetach();
        if(mListener != null){
            mListener.onClose(this);
            mListener = null;
        }
    }

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnScanResultListener {
        void onClose(ScanResultFragment sender);
    }
}
