//
//  SNetURL.swift
//  ObjToSwiftMigration
//
//  Created by SHABEERALI K on 24/01/19.
//  Copyright © 2019 SHABEERALI K. All rights reserved.
//

import Foundation


class SNetURL: NSObject {
    
    private var mEffectiveURL: String?
    private var mHttpCode: Int = 0
    private var mResponse: Data?
    
    /**
     time out
     */
    var timeout: Int = 0
    /**
     is http post
     */
    var isHttpPost = false
    /**
     follow location
     */
    var followLocation = false
    /**
     disable verify cert
     */
    var disableVerifyCert = false
    override init() {
        //if super.init()
        timeout = 20
        followLocation = true
        isHttpPost = false
    }
    
    func requestWithURL(url: String?, body: String?, bodyLen: Int) {
    
        
        mEffectiveURL = nil
        mResponse = nil
        
        let aReq = MsaHttpRequest()
        if let url = url {
            aReq.url = "\(url)"
        }
        aReq.body = Data(bytes: body, length: bodyLen)
        aReq.keepalive = false
        aReq.timeout = UInt(timeout)
        aReq.verifyCertFlag = !(disableVerifyCert)
        aReq.method = isHttpPost ? MSAHTTP_POST : MSAHTTP_GET
        aReq.urlRedirection = followLocation
        
        
        let aRsp: MsaHttpResponse? = MsaAccess.download(aReq)
        mHttpCode = aRsp?.retCode ?? 0
        mEffectiveURL = aRsp?.effectiveUrl ?? ""
        mResponse = aRsp?.body
    }
    /**
     init data with url
     
     @param aURL url
     @return NSData
     */
    func dataWithURL(aURL: String?) -> Data? {
        return dataWithURL(aURL: aURL, reqBody: nil)
    }
    /**
     data with url
     
     @param aURL url
     @param body body
     @return NSData
     */
    func dataWithURL(aURL: String?, reqBody body: String?) -> Data? {
        if body?.count==0 {
            requestWithURL(url:aURL, body: nil, bodyLen: 0)
        } else {
            requestWithURL(url:aURL, body: body, bodyLen: (body?.count)!)
        }
        return mResponse
    }
    /**
     string with url
     
     @param aURL url
     @return string
     */
    func stringWithURL(aURL: String?) -> String? {
        dataWithURL(aURL: aURL)
        if mResponse != nil {
            if let mResponse = mResponse {
                return String(data: mResponse, encoding: .utf8)
            }
            return nil
        }
        return nil
    }

    
    /**
     effective url
     
     @return string
     */
    func effectiveURL() -> String? {
        return mEffectiveURL
    }
    
    /**
     http code
     
     @return integer
     */
    func httpCode() -> Int {
        return mHttpCode
    }
    /**
     write file to path
     
     @param destPath dest path
     @param aURL url
     @return bool value
     */
    
    func writeFileToPath(destPath: String?, fromURL aURL: String?) -> Bool {
        return writeFileToPath(destPath: destPath, fromURL: aURL, timeout: 0)
    }
    /**
     write file to path
     
     @param destPath dest path
     @param aURL url
     @param timeout timeout
     @return bool value
     */
    func writeFileToPath(destPath: String?, fromURL aURL: String?, timeout: Int) -> Bool {
        
        return writeFileToPath(destPath:destPath, fromURL: aURL, reqBody: nil, timeout: timeout)
    }
    func writeFileToPath(destPath: String?, fromURL aURL: String?, reqBody body: String?, timeout: Int) -> Bool {
        if (destPath?.count ?? 0) == 0 || (aURL?.count ?? 0) == 0 || timeout <= 0 {
            return false
        }
        
        let download = MsaHttpDownLoadFile()
        download.url = aURL
        if (body?.count ?? 0) > 0 {
            download.body = Data(bytes: body?.utf8CString, length: body?.count ?? 0)
        }
        download.filePath = destPath
        download.timeout = UInt(timeout)
        download.verifyCertFlag = !(disableVerifyCert)
        download.method = isHttpPost ? MSAHTTP_POST : MSAHTTP_GET
        download.urlRedirection = followLocation
        
        let ret = MsaAccess.downloadFile(download, process: nil)
        mHttpCode = ret
        return ret == 0
    }

   
   
}
