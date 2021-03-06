//
// AnotherFakeAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
import Alamofire
import RxSwift



open class AnotherFakeAPI {
    /**
     To test special tags
     
     - parameter client: (body) client model 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func call123testSpecialTags(client: Client, completion: @escaping ((_ data: Client?,_ error: Error?) -> Void)) {
        call123testSpecialTagsWithRequestBuilder(client: client).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     To test special tags
     
     - parameter client: (body) client model 
     - returns: Observable<Client>
     */
    open class func call123testSpecialTags(client: Client) -> Observable<Client> {
        return Observable.create { observer -> Disposable in
            call123testSpecialTags(client: client) { data, error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     To test special tags
     - PATCH /another-fake/dummy
     - To test special tags and operation ID starting with number
     - parameter client: (body) client model 
     - returns: RequestBuilder<Client> 
     */
    open class func call123testSpecialTagsWithRequestBuilder(client: Client) -> RequestBuilder<Client> {
        let path = "/another-fake/dummy"
        let URLString = PetstoreClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: client)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Client>.Type = PetstoreClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PATCH", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
