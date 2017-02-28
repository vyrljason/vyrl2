//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

protocol Deserializable {
    func deserialize<Model: Decodable>(model: Model.Type, deserializer: ModelDeserializing) throws -> Model
}

extension Data : Deserializable {
    func deserialize<Model: Decodable>(model: Model.Type, deserializer: ModelDeserializing = JSONModelDeserializer()) throws -> Model {
        let model: Model = try deserializer.deserialize(data: self, model: model)
        return model
    }
}
