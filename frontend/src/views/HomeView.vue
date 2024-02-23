<script>
import axios from 'axios';
import router from "@/router/index.js";

const ip_start = "http://localhost:3001";
export default {
  data() {
    return {
      folders: [],
      documentTitle: '',
      documentType: '',
      documentId: ''
    };
  },
  methods: {
    async fetchData(url, method = 'GET', data = null) {
      try {
        const headers = {
          'Content-Type': 'application/json',
        };

        const options = {
          method,
          headers,
          url: url,
          withCredentials: true, // Ensure credentials are sent with the request
          data: JSON.stringify(data)
        };

        const response = await axios(options);

        console.log(response);

        if (!response.statusText === "Accepted") {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }

        return response;
      } catch (error) {
        console.error('Error fetching data:', error);
        throw error;
      }
    },

    async login() {
      const email = document.getElementById('username').value;
      const password = document.getElementById('password').value;

      const userData = {
        email,
        password
      };

      try {
        const loginResponse = await this.fetchData(ip_start + '/users', 'POST', userData);

        if (loginResponse.status === 202) {

          localStorage.setItem('userData', JSON.stringify(userData));
          await this.handleSuccessfulLogin(userData);
        } else {
          if (loginResponse.status === 401) {
            alert('Invalid username or password.');
          } else {
            alert('Unexpected error during login. Please try again.');
          }
          console.log('Login response:', loginResponse);
        }
      } catch (error) {
        console.error('Login error:', error);

        if (error.response) {
          console.error('Response details:', error.response.status, error.response.statusText);
          const responseBody = await error.response.json();
          console.error('Response body:', responseBody);
        }

        alert('Error during login. Please check console for details.');
      }
    },

    async handleSuccessfulLogin(userData) {
      console.log('Login successful.');
      await router.push('/about');

      // Call getFolders() to fetch and display folders
      await this.getFolders();
    },

    async getFolders() {
      try {
        const foldersResponse = await this.fetchData(ip_start + '/folders', 'GET');

        if (foldersResponse.status === 202) {
          // Display folders in the UI
          await this.displayFolders(foldersResponse.data.data);
        } else {
          console.error('Error fetching folders:', foldersResponse);
          alert('Error fetching folders. Please try again.');
        }
      } catch (error) {
        console.error('Error getting folders:', error);
        alert('Error getting folders. Please check console for details.');
      }
    },

    async displayFolders(folders) {
      const folderList = document.getElementById('folderList');
      console.log(folderList);
      folderList.innerHTML = ''; // Clear existing folder list

      for (const folder of folders) {
        const folderItem = document.createElement('li');
        folderItem.textContent = folder.PEALKIRI;

        // Attach a click event listener to each folder item
        folderItem.addEventListener('click', async (event) => {
          console.log('Folder clicked:', folder.PEALKIRI); // Add this line for debugging

          const clickedFolderItem = event.currentTarget;
          const contentList = clickedFolderItem.querySelector('ul');

          // If the folder is already open, close it and return
          if (contentList) {
            clickedFolderItem.removeChild(contentList);
            return;
          }

          // Otherwise, show the folder contents
          await this.showFolderContents(folder, clickedFolderItem); // Pass the clicked folder item as the second argument
        });

        folderItem.setAttribute('data-folder-id', folder.ID);
        folderList.appendChild(folderItem);
      }
    },

    async showFolderContents(folder, parentElement) {
      let contentList = parentElement.querySelector('ul');

      // If the folder is already open, close it and return
      if (contentList) {
        parentElement.removeChild(contentList);
        return;
      }

      // Create a new ul element to hold the contents
      contentList = document.createElement('ul');
      parentElement.appendChild(contentList);

      // Display documents
      for (const doc of folder.documents) {
        const documentItem = document.createElement('li');
        documentItem.textContent = doc.DOKUMENT_PEALKIRI;

        // Attach a click event listener to each document item
        documentItem.addEventListener('click', async (event) => {
          event.stopPropagation(); // Prevent the event from bubbling up to the folder
          await this.showDocumentDetails(doc);
        });

        contentList.appendChild(documentItem);
      }

      // Display subfolders
      for (const subfolder of folder.folders) {
        const folderItem = document.createElement('li');
        folderItem.textContent = subfolder.PEALKIRI;

        // Attach a click event listener to each folder item
        folderItem.addEventListener('click', async (event) => {
          event.stopPropagation(); // Prevent the event from bubbling up to the parent folder
          await this.showFolderContents(subfolder, folderItem); // Recursively show the subfolder contents
        });

        contentList.appendChild(folderItem);
      }
    },

    async showDocumentDetails(doc) {
      const documentTitle = document.getElementById('documentTitle');
      const documentType = document.getElementById('documentType');
      const documentId = document.getElementById('documentId');

      // Display document details in the UI
      documentTitle.textContent = doc.DOKUMENT_PEALKIRI;
      documentType.textContent = doc.DOKUMENT_TYYP;
      documentId.textContent = doc.ID;

      // Show the document details container
      document.getElementById('documentDetails').style.display = 'block';
    }
  }
}
</script>

<template>
  <div id="loginContainer" class="text-center">
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

  <div id="folders" style="display:none;" class="mt-4">
    <h3>Folders</h3>
    <ul id="folderList" class="list-group"></ul>
  </div>
</template>