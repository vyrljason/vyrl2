//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

enum UpdateUserProfileError: Error {
    case imageUpload
    case imagePost
    case userIndustriesUpdate
    case userProfileUpdate
}

protocol UserProfileUpdating {
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_parameter_count
    func update(avatarFilePath: URL?, discoverImageFilePath: URL?, userIndustries: UpdatedUserIndustries,
                fullName: String, bio: String, completion: @escaping (Result<Void, UpdateUserProfileError>) -> Void)
}

final class UserProfileUpdater: UserProfileUpdating {
    private let updateUserIndustriesService: UpdateUserIndustriesService
    private let updateUserProfileService: UpdateUserProfileService
    private let userImageUploadService: PostService<UploadUserImageResource>
    private let userImageUploadSignedRequest: UploadService<UploadUserImageSignedRequestResource>
    private let dispatchQueue: DispatchQueue
    private let dispatchGroup: DispatchGroup
    
    init(updateUserIndustriesService: UpdateUserIndustriesService,
         updateUserProfileService: UpdateUserProfileService,
         userImageUploadService: PostService<UploadUserImageResource>,
         userImageUploadSignedRequest: UploadService<UploadUserImageSignedRequestResource>) {
        self.userImageUploadService = userImageUploadService
        self.userImageUploadSignedRequest = userImageUploadSignedRequest
        self.updateUserIndustriesService = updateUserIndustriesService
        self.updateUserProfileService = updateUserProfileService
        self.dispatchQueue = DispatchQueue(label: "com.vyrl.dispatchgroup", attributes: .concurrent, target: .main)
        self.dispatchGroup = DispatchGroup()
    }
    
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_parameter_count
    func update(avatarFilePath: URL?, discoverImageFilePath: URL?, userIndustries: UpdatedUserIndustries,
                fullName: String, bio: String, completion: @escaping (Result<Void, UpdateUserProfileError>) -> Void) {
        var avatarUrl: URL? = nil
        if let avatarFilePath = avatarFilePath {
            upload(photoFilePath: avatarFilePath, photoType: .avatar, updateCompletion: completion, uploadCompletion: { imageUrl in
                avatarUrl = imageUrl
            })
        }
        var discoverImageUrl: URL? = nil
        if let discoverImageFilePath = discoverImageFilePath {
            upload(photoFilePath: discoverImageFilePath, photoType: .discoveryFeed, updateCompletion: completion, uploadCompletion: { imageUrl in
                discoverImageUrl = imageUrl
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let `self` = self else { return }
            self.updateUserIndustriesService.update(updatedUserIndustries: userIndustries, completion: { result in
                result.on(success: { _ in
                    let updatedUserProfile = UpdatedUserProfile(avatar: avatarUrl, discoveryFeedImage: discoverImageUrl,
                                                                bio: bio, fullName: fullName)
                    self.updateUserProfileService.update(updatedUserProfile: updatedUserProfile, completion: { userProfileResult in
                        userProfileResult.on(success: { _ in completion(.success()) }, failure: { _ in completion(.failure(.userProfileUpdate)) })
                    })
                }, failure: { _ in completion(.failure(.userProfileUpdate)) })
            })
        }
    }
    
    private func upload(photoFilePath: URL, photoType: UserImageType, updateCompletion: @escaping (Result<Void, UpdateUserProfileError>) -> Void, uploadCompletion: @escaping (URL) -> Void) {
        dispatchGroup.enter()
        dispatchQueue.async (group: dispatchGroup) { [weak self] in
            guard let `self` = self else { return }
            self.userImageUploadService.post(using: photoType) { result in
                result.on(success: { userImageUploadResponse in
                    self.userImageUploadSignedRequest.upload(using: photoFilePath, toStringUrl: userImageUploadResponse.signedRequest) { result in
                        result.on(success: { _ in
                            uploadCompletion(userImageUploadResponse.url)
                            self.dispatchGroup.leave()
                        }, failure: { _ in
                            updateCompletion(.failure(.imageUpload))
                            self.dispatchGroup.leave()
                            return
                        })
                    }
                }, failure: { _ in
                    updateCompletion(.failure(.imageUpload))
                    self.dispatchGroup.leave()
                    return
                })
            }
        }
    }
}
