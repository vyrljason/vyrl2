//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

protocol ModelDeserializing {
    func deserialize<Model: Decodable>(data: Data, model: Model.Type) throws -> Model
}

final class JSONModelDeserializer: ModelDeserializing {

    private let serializatorClass: JSONSerializationProtocol.Type

    init(serializator: JSONSerializationProtocol.Type = JSONSerialization.self) {
        serializatorClass =  serializator
    }

    func deserialize<Model: Decodable>(data: Data, model: Model.Type) throws -> Model {
        let json = try serializatorClass.JSONObjectWithData(data, options: JSONSerialization.ReadingOptions())
        let model = try model.decode(json)
        return model
    }
}
