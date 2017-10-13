node {
    stage('Checkout') {
        // git url: 'https://github.com/dannybrody/web-app.git'
        git([url: 'https://github.com/dannybrody/web-app.git', branch: 'master'])
    }
    
    stage('Get Dependencies') {
        sh 'go version'
        sh 'go get -v -d'
    }
    stage('Test') {
        sh 'go vet'
        sh 'go test -cover'
    }
    stage('Build') {
        sh 'go build .'
    }
    
}