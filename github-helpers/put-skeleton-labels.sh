    # hySpc.read.mat shell script 
    # author: Erick Oduniyi 
    
    # Make sure github-labels node package is installed
    npm install github-labels -g
    
    # Get Github username and repo name
    echo "enter username and name of derived package repository (username/repo)"
    read pkg_repo
   
    # Get personal access tokens
    echo "enter Personal access tokens"
    read token
   
    # Pass the hySpc.read.mat labels to the derived package repo
    labels -c hypSpc.hySpc.read.mat.labels.json pkg_repo -t token
