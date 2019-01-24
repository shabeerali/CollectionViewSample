//
//  SNetTask.swift
//  ObjToSwiftMigration
//
//  Created by SHABEERALI K on 24/01/19.
//  Copyright © 2019 SHABEERALI K. All rights reserved.
//

import Foundation

import Foundation

typealias RationalCheckRef = (OTTReqRef?) -> Bool


private var gSNetTaskNormal = true
private var gRationalCheck: RationalCheckRef? = nil
private var gTimeout: UInt = 0
private var gErrorArray: [NSNumber]? = nil
private var gDisableVerifyHttpsCert = false
/*!
 @class SNetTask
 @superclass NSObject
 @abstract This class is a vsp interface access class, you can send a request and implement callback in block
 
 */
class SNetTask: NSObject {
    //! task queue
    var mTaskQue: [AnyHashable] = []
    
    private var access: MsaAccess?
    
    override init() {
        //if super.init()
        access = MsaAccess()
    }
    
    /*!
     @abstract send a request and implement callback in block
     @param aReq a request confirm OTTPackageProtocol and OTTRequestProtocol
     @param success sucess receive response from server, aReq is the sent request, aRsp is response from server
     @param failure failed receive from server. you can get detailed information from error
     @return if SNetTask and param is nomarl return YES otherwise return NO
     */
    func send(_ aReq: OTTReqRef?, success: @escaping (_ aReq: OTTReqRef?, _ aRsp: OTTRspRef?) -> Void, failure: @escaping (_ aReq: OTTReqRef?, _ error: Error?) -> Void) -> Bool {
        return send(aReq, success: success, failure: failure, retryTimes: 0)
    }
    
    
    /*!
     @abstract send a request and implement callback in block
     @param aReq a request confirm OTTPackageProtocol and OTTRequestProtocol
     @param success sucess receive response from server, aReq is the sent request, aRsp is response from server
     @param failure failed receive from server. you can get detailed information from error
     @param rtimes if rtimes > 0 ,and you have rigisterd retry NSError use registerRetryNSErrorArray, snettask will auto resend again until success or failure reach rtimes
     @return if SNetTask and param is nomarl return YES otherwise return NO
     */
    func send(_ aReq: OTTReqRef?, success: @escaping (_ aReq: OTTReqRef?, _ aRsp: OTTRspRef?) -> Void, failure: @escaping (_ aReq: OTTReqRef?, _ error: Error?) -> Void, retryTimes rtimes: Int) -> Bool {
     
        DS_DEBUG("SNetTask send \"%@\", level = %ld", NSStringFromClass(aReq.self.self), Int(aReq?.reqLevel() ?? 0))
        if !gSNetTaskNormal {
            DS_DEBUG("SNetTask have benn called stopTask, need call resumeTask first, request will be discarded")
            let error = NSError(domain: "SystemRestart", code: OTT_SYSTEM_CANCEL_REQUEST, userInfo: nil)
            failure(aReq, error)
            return false
        }
        
        if gRationalCheck != nil {
            if !gRationalCheck?(aReq) {
                DS_ERROR("SNetTask rational check failed for %@", NSStringFromClass(aReq.self.self))
                let error = NSError(domain: "SystemRestart", code: OTT_SYSTEM_LOGIN_OCCASION, userInfo: nil)
                failure(aReq, error)
                return false
            }
        }
        
        let myReq = SNetTaskReq(ottReq: aReq)
        myReq.isPrintLog = true
        myReq.successBlock = success
        myReq.failureBlock = failure
        

       if gTimeout > 0 {
            myReq.httpReq.timeout = gTimeout
        }
        
        if rtimes > 0 && gErrorArray.count > 0 {
            myReq.httpReq.retryTimes = UInt(rtimes)
            myReq.httpReq.retryExceptionCode = gErrorArray
        }
        
        if gDisableVerifyHttpsCert {
            myReq.httpReq.verifyCertFlag = false
        }
        
        
        
        //__weak __typeof(self) weakSelf = self;
        access?.send(myReq) { aReq, aRsp in
            let request = aReq as? SNetTaskReq
            let response = aRsp as? SNetTaskRsp
            if aRsp?.success() != nil {
                SNETCEvent.unified.successReceiveResponse(response?.ottRsp, request: request?.ottReq, isCache: true)
                request?.successBlock(request?.ottReq, response?.ottRsp)
            } else {
                let errorCode = Int(response?.httpRsp.retCode ?? 0)
                let error = NSError(domain: "MsaHttpError", code: errorCode, userInfo: nil)
                request?.failureBlock(request?.ottReq, error)
            }
        }
        
        return true
    }
    
    /*!
     @abstract cancel all the requests on the SNetTask
     */
    func cancel() {
        access?.cancel()
    }
    deinit {
        cancel()
        // NSLog(@"%@ dealloc", NSStringFromClass([self class]));
    }
    
}
extension SNetTask {
    class func cancelPreviousRequests() {
        DS_DEBUG("SNetTask cancelPreviousRequests")
        MsaAccess.cancelPreviousRequests()
    }
    
    class func resetRequestTimeoutSeconds(_ timeout: Int) {
        if timeout > 0 {
            gTimeout = UInt(timeout)
        }
        
    }
    
    class func stop() {
        DS_DEBUG("%@ : %s", NSStringFromClass(SNetTask.self), __func__)
        gSNetTaskNormal = false
    }
    
    class func resumeTask() {
        DS_DEBUG("%@ : %s", NSStringFromClass(SNetTask.self), __func__)
        gSNetTaskNormal = true
    }
    class func registerRationalCheck(_ rcheck: RationalCheckRef?) {
        DS_DEBUG("%@ : %s", NSStringFromClass(SNetTask.self), __func__)
        gRationalCheck = rcheck
    }
    
    class func resetHttpHead(_ httphead: [AnyHashable]?) {
        var httphead = httphead
        DS_DEBUG("%@ : %s", NSStringFromClass(SNetTask.self), __func__)
        MsaAccess.httpHeader = httphead
    }
    
    class func resetHttpKeepAliveSeconds(_ seconds: Int) {
        DS_DEBUG("%@ : %s", NSStringFromClass(SNetTask.self), __func__)
        
    }
    
    class func resetCertPath(_ certPath: String?) {
        MsaAccess.certificate = certPath
    }
    
    class func registerRetryNSErrorArray(_ errorArray: [NSNumber]?) {
        if let errorArray = errorArray {
            gErrorArray = errorArray
        }
    }
    
    class func disableVerifyHttpsCert() {
        gDisableVerifyHttpsCert = true
    }
    
}
