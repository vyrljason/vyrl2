//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

protocol JSONToModelDeserializing: class {
    func deserialize<Model: Decodable>(json: Any, model: Model.Type) throws -> Model
}

protocol DataToModelDeserializing {
    func deserialize<Model: Decodable>(data: Data, model: Model.Type) throws -> Model
}

protocol Deserializable {
    func deserialize<Model: Decodable>(model: Model.Type, deserializer: DataToModelDeserializing) throws -> Model
}

final class JSONToModelDeserializer: JSONToModelDeserializing {
    func deserialize<Model: Decodable>(json: Any, model: Model.Type) throws -> Model {
        let model = try model.decode(json)
        return model
    }
}

extension Data : Deserializable {
    func deserialize<Model: Decodable>(model: Model.Type,
                     deserializer: DataToModelDeserializing = DataToModelJSONDeserializer()) throws -> Model {
        let model: Model = try deserializer.deserialize(data: self, model: model)
        return model
    }
}


