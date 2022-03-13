package com.example.tronic_ballot;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Environment;
import android.os.SystemClock;
import android.util.Base64;
import android.util.Log;
import android.widget.Toast;
// import io.flutter.app.FlutterActivity;
import com.mantra.mfs100.FingerData;
import com.mantra.mfs100.MFS100;
import com.mantra.mfs100.MFS100Event;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity implements MFS100Event {

    String encodedData = null;
    int score;
    private FingerData lastCapFingerData = null;
    private static long Threshold = 1500;
    private static final String CHANNEL = "flutter.native/helper";
    MFS100 mfs100 = null;
    private boolean isCaptureRunning = false;

    private enum ScannerAction {
        Capture, Verify
    }

    ScannerAction scannerAction = ScannerAction.Capture;
    int timeout = 10000;
    byte[] Enroll_Template;
    byte[] Verify_Template;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this.getFlutterEngine());

        try {
            mfs100 = new MFS100(this);
            mfs100.SetApplicationContext(MainActivity.this);
        } catch (Exception e) {
            e.printStackTrace();
        }

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {

                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {


                        switch (call.method.toString()) {
                            case "Initialize_Capture":
//                            System.out.println("Initialize");
                                InitScanner();
                                scannerAction = ScannerAction.Capture;
                                if (!isCaptureRunning) {
                                    StartSyncCapture();


                                }
                                break;  //optional
                            case "UnInit_PassMatchData":
                                Enroll_Template = null;

//                            System.out.println("Capture");
                                result.success(score);
                                UnInitScanner();

                                score = 0;
                                break;  //optional
                            case "Match":


                                Enroll_Template = new byte[Base64.decode(call.arguments.toString(), Base64.DEFAULT).length];
                                System.arraycopy(Base64.decode(call.arguments.toString(), Base64.DEFAULT), 0, Enroll_Template, 0,
                                        Base64.decode(call.arguments.toString(), Base64.DEFAULT).length);
                                InitScanner();

                                scannerAction = ScannerAction.Verify;
                                if (!isCaptureRunning) {
                                    StartSyncCapture();
                                }
                                result.success("DOne");
                                break;  //optional
                            case "PassData":
//                            System.out.println("UnInit");
                                result.success(encodedData);
                                encodedData = null;
                                Enroll_Template = null;
                                break;  //optional

                        }

                    }
                });
    }

    @Override
    protected void onStart() {

        try {
            if (mfs100 == null) {
                mfs100 = new MFS100(this);
                mfs100.SetApplicationContext(MainActivity.this);
            } else {
                InitScanner();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        super.onStart();
    }

    private void InitScanner() {
        try {
            int ret = mfs100.Init();
            if (ret != 0) {

                System.out.println(mfs100.GetErrorMsg(ret));
            } else {

                System.out.println("Init success");
                String info = "Serial: " + mfs100.GetDeviceInfo().SerialNo()
                        + " Make: " + mfs100.GetDeviceInfo().Make()
                        + " Model: " + mfs100.GetDeviceInfo().Model()
                        + "\nCertificate: " + mfs100.GetCertification();

                System.out.println(info);
            }
        } catch (Exception ex) {
            Toast.makeText(getApplicationContext(), "Init failed, unhandled exception",
                    Toast.LENGTH_LONG).show();

            System.out.println("Init failed, unhandled exception");
        }
    }

    private void StartSyncCapture() {
        new Thread(new Runnable() {

            @Override
            public void run() {

                isCaptureRunning = true;
                try {
                    FingerData fingerData = new FingerData();
                    int ret = mfs100.AutoCapture(fingerData, timeout, false);
                    Log.e("StartSyncCapture.RET", "" + ret);
                    if (ret != 0) {
                        System.out.println(mfs100.GetErrorMsg(ret));
                    } else {
                        lastCapFingerData = fingerData;

                        final Bitmap bitmap = BitmapFactory.decodeByteArray(fingerData.FingerImage(), 0,
                                fingerData.FingerImage().length);
//                        MainActivity.this.runOnUiThread(new Runnable() {
//                            @Override
//                            public void run() {
//                                imgFinger.setImageBitmap(bitmap);
//                            }
//                        }
//                        );
//System.out.println(Base64.encodeToString(fingerData.ISOTemplate(), Base64.DEFAULT));
//                        Log.e("RawImage", Base64.encodeToString(fingerData.RawData(), Base64.DEFAULT));
//                        Log.v("FingerISOTemplate", Base64.encodeToString(fingerData.ISOTemplate(), Base64.DEFAULT));
                        System.out.println("Capture Success");
                        String log = "\nQuality: " + fingerData.Quality()
                                + "\nNFIQ: " + fingerData.Nfiq()
                                + "\nWSQ Compress Ratio: "
                                + fingerData.WSQCompressRatio()
                                + "\nImage Dimensions (inch): "
                                + fingerData.InWidth() + "\" X "
                                + fingerData.InHeight() + "\""
                                + "\nImage Area (inch): " + fingerData.InArea()
                                + "\"" + "\nResolution (dpi/ppi): "
                                + fingerData.Resolution() + "\nGray Scale: "
                                + fingerData.GrayScale() + "\nBits Per Pixal: "
                                + fingerData.Bpp() + "\nWSQ Info: "
                                + fingerData.WSQInfo();
                        System.out.println(log);
                        SetData2(fingerData);
                    }
                } catch (Exception ex) {
                    System.out.println("Error");
                } finally {
                    isCaptureRunning = false;
                }
            }
        }).start();
    }

    private void UnInitScanner() {
        try {
            int ret = mfs100.UnInit();
            if (ret != 0) {

                System.out.println(mfs100.GetErrorMsg(ret));
            } else {

                System.out.println("Uninit Success");
                lastCapFingerData = null;
            }
        } catch (Exception e) {
            Log.e("UnInitScanner.EX", e.toString());
        }
    }

    private void WriteFile(String filename, byte[] bytes) {
        try {
            String path = Environment.getExternalStorageDirectory()
                    + "//FingerData";
            File file = new File(path);
            if (!file.exists()) {
                file.mkdirs();
            }
            path = path + "//" + filename;
            file = new File(path);
            if (!file.exists()) {
                file.createNewFile();
            }
            FileOutputStream stream = new FileOutputStream(path);
            stream.write(bytes);
            stream.close();
        } catch (Exception e1) {
            e1.printStackTrace();
        }
    }

    protected void onStop() {
        try {
            if (isCaptureRunning) {
                int ret = mfs100.StopAutoCapture();
            }
            Thread.sleep(500);
            //            UnInitScanner();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        super.onStop();
    }


    @Override
    protected void onDestroy() {
        try {
            if (mfs100 != null) {
                mfs100.Dispose();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        super.onDestroy();
    }


    public void SetData2(FingerData fingerData) {
        try {
            if (scannerAction.equals(ScannerAction.Capture)) {
                encodedData = Base64.encodeToString(fingerData.ISOTemplate(), Base64.DEFAULT);
//                Enroll_Template = new byte[fingerData.ISOTemplate().length];
//                System.arraycopy(fingerData.ISOTemplate(), 0, Enroll_Template, 0,
//                        fingerData.ISOTemplate().length);


            } else if (scannerAction.equals(ScannerAction.Verify)) {
                if (Enroll_Template == null) {
                    return;
                }
                Verify_Template = new byte[fingerData.ISOTemplate().length];
                System.arraycopy(fingerData.ISOTemplate(), 0, Verify_Template, 0,
                        fingerData.ISOTemplate().length);
                int ret = mfs100.MatchISO(Enroll_Template, Verify_Template);
                if (ret < 0) {
                    System.out.println("Error: " + ret + "(" + mfs100.GetErrorMsg(ret) + ")");
                } else {
                    score = ret;
                    System.out.println("Score: " + ret);
//                    if (ret >= 96) {
//                        System.out.println("Finger matched with score: " + ret);

//                    } else {
//                        System.out.println("Finger not matched, score: " + ret);
//                        score=ret;
//                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

//        try {
        WriteFile("Raw.raw", fingerData.RawData());
//            WriteFile("Bitmap.bmp", fingerData.FingerImage());
//            WriteFile("ISOTemplate.iso", fingerData.ISOTemplate());
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
    }

    private long mLastAttTime = 0l;

    @Override
    public void OnDeviceAttached(int vid, int pid, boolean hasPermission) {

        if (SystemClock.elapsedRealtime() - mLastAttTime < Threshold) {
            return;
        }
        mLastAttTime = SystemClock.elapsedRealtime();
        int ret;
        if (!hasPermission) {

            System.out.println("Permission denied");
            return;
        }
        try {
            if (vid == 1204 || vid == 11279) {
                if (pid == 34323) {
                    ret = mfs100.LoadFirmware();
                    if (ret != 0) {

                        System.out.println(mfs100.GetErrorMsg(ret));
                    } else {

                        System.out.println("Load firmware success");
                    }
                } else if (pid == 4101) {
                    String key = "Without Key";
                    ret = mfs100.Init();
                    if (ret == 0) {
                        showSuccessLog(key);
                    } else {

                        System.out.println(mfs100.GetErrorMsg(ret));
                    }

                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void showSuccessLog(String key) {
        try {

            System.out.println("Init success");
            String info = "\nKey: " + key + "\nSerial: "
                    + mfs100.GetDeviceInfo().SerialNo() + " Make: "
                    + mfs100.GetDeviceInfo().Make() + " Model: "
                    + mfs100.GetDeviceInfo().Model()
                    + "\nCertificate: " + mfs100.GetCertification();

            System.out.println(info);
        } catch (Exception e) {
        }
    }

    long mLastDttTime = 0l;

    @Override
    public void OnDeviceDetached() {
        try {

            if (SystemClock.elapsedRealtime() - mLastDttTime < Threshold) {
                return;
            }
            mLastDttTime = SystemClock.elapsedRealtime();
            UnInitScanner();


            System.out.println("Device removed");
        } catch (Exception e) {
        }
    }

    @Override
    public void OnHostCheckFailed(String err) {
        try {

            System.out.println(err);
            Toast.makeText(getApplicationContext(), err, Toast.LENGTH_LONG).show();
        } catch (Exception ignored) {
        }
    }
}
