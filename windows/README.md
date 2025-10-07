now, if you really need to use windows, then we have to minimize the risk of feeling dumb.  
the code will still run on linux (compatibility thing), but like in a self contained small application on your windows machine, so none of your personal files won't be touched.

to prepare your windows environment, we provide [a PowerShell script](./setup-wsl.ps1) that downloads and sets up Ubuntu VM through WSL2 (Windows Subsystem for Linux), handling installation of all dependencies that you might need during the development.

steps:
1. run PowerShell script (right-click then run in powershell)
2. setup will now happen and when finished, a new window with linux terminal will open
3. type `docker run hello-world` to confirm that setup went succesfully
4. now we will set up github cli: at first we need to log in, using `gh auth login` shell command
    - select Github.com (default) and press enter
    - select HTTPS (default) and press enter
    - select Login with a web browser (default) and press enter
    - copy the one time code to clipboard and open the link [https://github.com/login/device](https://github.com/login/device)
    - login to your github account, provide code and go through authentication process
    - when done in browser, get back to terminal window and click enter
    - it will fail at opening error, but will wait and eventually display your github name

now you can proceed with project setup instructions for repo you'll be working on