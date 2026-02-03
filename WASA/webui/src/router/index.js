import { createRouter, createWebHashHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import LoginView from '../views/LoginView.vue';
import UserChatsView from '../views/UserChatsView.vue'; 
import CreateGroupView from '../views/CreateGroupView.vue'; 
import SearchUserView from '../views/SearchUserView.vue';
import ChatView from '../views/ChatView.vue';
import ModifyGroup from '../views/ModifyGroup.vue';
import ModifyUser from '../views/ModifyUser.vue';
import GroupMembersView from '../views/GroupMembersView.vue';
import ForwardView from '../views/ForwardView.vue';

const router = createRouter({
  history: createWebHashHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'Home',
      component: HomeView, 
    },
    {
      path: '/login',
      name: 'Login',
      component: LoginView,  
    },
    {
      path: '/wasachat/:nickname/chats', 
      name: 'UserChats',
      component: UserChatsView,  
      props: true, 
    },
    {
      path: '/wasachat/:nickname/chats/creategroup',
      name: 'CreateGroup',
      component: CreateGroupView,  
    },

    {
      path: '/wasachat/:nickname/chats/searchuser',
      name: 'SearchUser',
      component: SearchUserView,  
    },

    {
      path: '/wasachat/:nickname/chats/:chat/partecipanti',
      name: 'GroupMembersView',
      component: GroupMembersView,  
    },

    {
      path: '/wasachat/:nickname/chats/:chat',
      name: 'ChatView',
      component: ChatView,  
    },

    {
      path: '/wasachat/:nickname/chats/:chat/settings',
      name: 'ModifyGroup',
      component: ModifyGroup,  
    },

    {
      path: '/wasachat/:nickname/settings',
      name: 'ModifyUser',
      component: ModifyUser,  
    },

    {
      path: '/wasachat/:nickname/:chat/forward/:message',
      name: 'ForwardView',
      component: ForwardView,  
    },
  ],
});

export default router;