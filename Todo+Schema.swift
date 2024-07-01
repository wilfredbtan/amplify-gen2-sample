// swiftlint:disable all
import Amplify
import Foundation

extension Todo {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case content
    case isDone
    case _version
    case _deleted
    case _lastChangedAt
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let todo = Todo.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Todos"
    model.syncPluralName = "Todos"
    
    model.attributes(
      .primaryKey(fields: [todo.id])
    )
    
    model.fields(
      .field(todo.id, is: .required, ofType: .string),
      .field(todo.content, is: .optional, ofType: .string),
      .field(todo.isDone, is: .required, ofType: .bool),
      .field(todo._version, is: .optional, ofType: .int),
      .field(todo._deleted, is: .optional, ofType: .bool),
      .field(todo._lastChangedAt, is: .optional, ofType: .int),
      .field(todo.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(todo.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<Todo> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension Todo: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == Todo {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var content: FieldPath<String>   {
      string("content") 
    }
  public var isDone: FieldPath<Bool>   {
      bool("isDone") 
    }
  public var _version: FieldPath<Int>   {
      int("_version") 
    }
  public var _deleted: FieldPath<Bool>   {
      bool("_deleted") 
    }
  public var _lastChangedAt: FieldPath<Int>   {
      int("_lastChangedAt") 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}