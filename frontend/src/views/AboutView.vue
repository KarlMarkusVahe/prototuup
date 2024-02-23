<script>
import HomeView from './HomeView.vue'; // Move this line to the top
import axios from 'axios';

const ip_start = "http://localhost:3001";
export default {
  components: {
    HomeView,
  },
  data() {
    return {
      folders: [] // Assuming this is where you store the folders
    };
  },
  methods: {
    async logout() {
      try {
        const userData = JSON.parse(localStorage.getItem('userData'));

        // Make a request to your server to destroy the session
        await axios.delete('http://localhost:3001/users', {
          withCredentials: true, // Ensure credentials are sent with the request
          headers: {
            'Content-Type': 'application/json',
            // Add any additional headers needed for authentication
            // For example, if using a token: 'Authorization': `Bearer ${userData.token}`
          },
        });

        // Clear client-side stored data
        localStorage.removeItem('userData');

        // Hide folders and document details, show the login form, and hide the logout button
        this.showLogin();
        console.log('Logout successful.');
      } catch (error) {
        console.error('Error during logout:', error);
        alert('Error during logout. Please check console for details.');
      }
    },
    async showFolders() {
      // Assuming this function populates the folders array
      await this.getFolders();

      await this.displayFolders();
    },
    async displayFolders() {
      // Assuming this function is in HomeView and takes folderList as a parameter
      await this.$refs.homeView.displayFolders(this.folders);
    },
    async updatePrivileges(id, email, privileges) {
      try {
        const response = await axios.put(`${ip_start}/${id}/privileges`, {
          email: email,
          privileges: privileges
        }, {
          headers: {
            'Content-Type': 'application/json'
          },
          withCredentials: true, // Ensure credentials are sent with the request
        });
        console.log(response.data);
      } catch (error) {
        console.error('Error updating privileges:', error);
        alert('Error updating privileges. Please check console for details.');
      }
    },
    shareDocument() {
      let id = document.getElementById('documentId').innerText;
      let email = prompt("Please enter the email of the user you want to share with:");
      let privileges = {
        READ_PRIVILEEG: true,
        WRITE_PRIVILEEG: false,
        DELETE_PRIVILEEG: false
      };
      this.updatePrivileges(id, email, privileges);
    },
    showLogin() {
      document.getElementById('loginContainer').style.display = 'block';
      document.getElementById('folders').style.display = 'none';
      document.getElementById('documentDetails').style.display = 'none';
      document.getElementById('logoutContainer').style.display = 'none';
    },
  },
  mounted() {
    // Check if user is already logged in
    const userData = JSON.parse(localStorage.getItem('userData'));
    if (userData) {
      this.showFolders();
    } else {
      this.showLogin();
    }
  }
}
</script>

<template>
  <div id="loginContainer" style="display:none;" class="text-center">
    <h3>Login</h3>
    <form id="loginForm">
      <div class="form-group">
        <label for="username">Username:</label>
        <input type="text" class="form-control" id="username" required>
      </div>
      <div class="form-group">
        <label for="password">Password:</label>
        <input type="password" class="form-control" id="password" required>
      </div>
      <button type="button" class="btn btn-primary" @click="login">Login</button>
    </form>
  </div>

  <div id="logoutContainer">
    <button class="btn btn-danger" @click="logout">Logout</button>
  </div>

  <input type="text" id="myInput" @keyup="filter" placeholder="Search for names..">

  <div id="folders" class="mt-4">
    <h3>Folders</h3>
    <ul id="folderList" class="list-group"></ul>
  </div>

  <div id="documentDetails" class="mt-4">
    <h3>Document Details</h3>
    <p><strong>Title:</strong> <span id="documentTitle"></span></p>
    <p><strong>Document Type:</strong> <span id="documentType"></span></p>
    <p><strong>ID:</strong> <span id="documentId"></span></p>
    <button id="shareButton" class="btn btn-primary" @click="shareDocument">Share</button>
  </div>

</template>