import { defineStorage } from '@aws-amplify/backend';

export const storage = defineStorage({
    name: 'amplifyTeamDrive',
    access: (allow) => ({
        'todos/{entity_id}/*': [
            allow.guest.to(['read']),
            allow.entity('identity').to(['read', 'write', 'delete'])
        ]
    })
});
