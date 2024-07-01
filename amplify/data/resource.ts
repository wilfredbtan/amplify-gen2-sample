import { type ClientSchema, a, defineData } from '@aws-amplify/backend';

const schema = a.schema({
  Todo: a
  .model({
    content: a.string(),
    isDone: a.boolean().required(),
    _version: a.integer(),
    _deleted: a.boolean(),
    _lastChangedAt: a.integer()
  })
    .authorization((allow) => [allow.owner()])
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'userPool'
  }
});
