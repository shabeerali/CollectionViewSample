//
//  SNetTaskReq.swift
//  ObjToSwiftMigration
//
//  Created by SHABEERALI K on 24/01/19.
//  Copyright © 2019 SHABEERALI K. All rights reserved.
//

import Foundation


class SNetTaskReq: MsaAccessRequest {
    /**
     OTT request
     */
    var ottReq: OTTReqRef?
    /**
     * the callback of response successfuly with the request
     */
    var successBlock: ((OTTReqRef?, OTTRspRef?) -> Void)?
    /**
     * the callback of response failed with the errorcode duo to the request
     */
    var failureBlock: ((OTTReqRef?, Error?) -> Void)?
    /**
     * when send the request ,the callback of cacel network lation
     */
    var cancellationBlock: ((OTTReqRef?) -> Void)?
    
    /**
     * init with the OTT request
     
     @param ottReq a request confirm OTTReqRef
     @return return the calss own type
     */
    
    init(ottReq: OTTReqRef?) {
        //if super.init()
        self.ottReq = ottReq
        httpReq.url = ottReq?.reqURL()
        if ottReq?.httpPostMethod() != nil {
            httpReq.method = MSAHTTP_POST
        } else {
            httpReq.method = MSAHTTP_GET
        }
        
        if ottReq?.writeDownInLog() != nil {
            isPrintLog = true
        }
    }
    
    func prepare() {
        httpReq.body = ottReq.pack()
    }
    
    func response() -> MsaAccessResponse? {
        let aRsp = SNetTaskRsp()
        aRsp.ottRsp = ottReq.rspObject() as? OTTRspRef?
        return aRsp
    }
    
    
}
