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
  mounted() {
    // Check if user is already logged in
    const userData = JSON.parse(localStorage.getItem('userData'));
    if (userData) {
      this.showFolders();
    } else {
      this.showLogin();
    }
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
      const folders = await this.getFolders();

      await this.displayFolders(folders);
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
    async getFolders() {
      try {
        const foldersResponse = await this.fetchData(ip_start + '/folders', 'GET');

        if (foldersResponse.status === 202) {
          // Return folders from response
          return foldersResponse.data.data;
        } else {
          console.error('Error fetching folders:', foldersResponse);
          alert('Error fetching folders. Please try again.');
        }
      } catch (error) {
        console.error('Error getting folders:', error);
        alert('Error getting folders. Please check console for details.');
      }
    },
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
    // filter function
    filter() {
      // Declare variables
      var input, filter, ul, li, a, i, txtValue;
      input = document.getElementById('myInput');
      filter = input.value.toUpperCase();
      ul = document.getElementById("folderList");
      li = ul.getElementsByTagName('li');

      // Loop through all list items, and hide those who don't match the search query
      for (i = 0; i < li.length; i++) {
        a = li[i];
        txtValue = a.textContent || a.innerText;
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
          li[i].style.display = "";
        } else {
          li[i].style.display = "none";
        }
      }
    },
    async showDocumentDetails(doc) {
      const documentTitle = document.getElementById('documentTitle');
      const documentType = document.getElementById('documentType');
      const documentId = document.getElementById('documentId');

      // Display document details in the UI
      documentTitle.textContent = doc.DOKUMENT_PEALKIRI;
      documentType.textContent = doc.DOKUMENT_TYYP;
      documentId.textContent = doc.DocumentID;

      // Show the document details container
      document.getElementById('documentDetails').style.display = 'block';
    },
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