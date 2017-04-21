//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

enum UpdateUserProfileError: Error {
    case imageConversion
    case imageUpload
    case imagePost
    case userIndustriesUpdate
    case userProfileUpdate
}

protocol UserProfileUpdating {
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_parameter_count
    func update(avatar: UIImage?, discoverImage: UIImage?, userIndustries: UpdatedUserIndustries,
                fullName: String, bio: String, completion: @escaping (Result<Void, UpdateUserProfileError>) -> Void)
}

final class UserProfileUpdater: UserProfileUpdating {
    private let imageUploader: ImageDataUploading
    private let imageConverter: ImageToDataConverting
    private let updateUserIndustriesService: UpdateUserIndustriesService
    private let updateUserProfileService: UpdateUserProfileService
    private let dispatchQueue: DispatchQueue
    private let dispatchGroup: DispatchGroup
    
    init(updateUserIndustriesService: UpdateUserIndustriesService,
         updateUserProfileService: UpdateUserProfileService,
         imageUploader: ImageDataUploading,
         imageConverter: ImageToDataConverting) {
        self.imageUploader = imageUploader
        self.imageConverter = imageConverter
        self.updateUserIndustriesService = updateUserIndustriesService
        self.updateUserProfileService = updateUserProfileService
        self.dispatchQueue = DispatchQueue(label: "com.vyrl.dispatchgroup", attributes: .concurrent, target: .main)
        self.dispatchGroup = DispatchGroup()
    }
    
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_parameter_count
    func update(avatar: UIImage?, discoverImage: UIImage?, userIndustries: UpdatedUserIndustries,
                fullName: String, bio: String, completion: @escaping (Result<Void, UpdateUserProfileError>) -> Void) {
        var avatarUrl: URL? = nil
        if let avatar = avatar {
            upload(photo: avatar, updateCompletion: completion, uploadCompletion: { imageUrl in
                avatarUrl = imageUrl
            })
        }
        var discoverImageUrl: URL? = nil
        if let discoverImage = discoverImage {
            upload(photo: discoverImage, updateCompletion: completion, uploadCompletion: { imageUrl in
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
    
    private func upload(photo: UIImage, updateCompletion: @escaping (Result<Void, UpdateUserProfileError>) -> Void, uploadCompletion: @escaping (URL) -> Void) {
        dispatchGroup.enter()
        dispatchQueue.async (group: dispatchGroup) { [weak self] in
            guard let photoData = self?.imageConverter.convert(image: photo) else {
                updateCompletion(.failure(.imageConversion))
                self?.dispatchGroup.leave()
                return
            }
            self?.imageUploader.upload(imageData: photoData) { [weak self] uploadResult in
                guard let `self` = self else { return }
                uploadResult.on(success: { imageContainer in
                    uploadCompletion(imageContainer.url)
                    self.dispatchGroup.leave()
                }, failure: { _ in
                    updateCompletion(.failure(.imageUpload))
                    self.dispatchGroup.leave()
                    return
                })
            }
        }
    }
}
