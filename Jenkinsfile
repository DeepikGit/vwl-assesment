pipeline {
  agent any

  environment {
    // Use build number for versioning
    IMAGE_NAME = "deepikdc/vwl_repo:shoplist-app-${BUILD_NUMBER}"
    DOCKER_CREDENTIALS_ID = 'dockerhub-creds' // Replace with your Jenkins credentials ID
  }

  stages {
    stage('Checkout') {
      steps {
        echo "📥 Checking out code..."
        checkout scm
      }
    }

    stage('Semgrep Scan') {
      steps {
        echo "🔎 Running Semgrep scan..."
        sh '''
          semgrep scan --config=auto --json > semgrep-report.json || true

          if grep -iq '"severity": "ERROR"' semgrep-report.json; then
            echo "❌ Semgrep found ERROR-level issues. Failing build."
            exit 1
          fi
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        echo "🐳 Building Docker image: $IMAGE_NAME"
        sh "docker build -t $IMAGE_NAME ."
      }
    }

    stage('Trivy Scan') {
      steps {
        echo "🛡️ Scanning Docker image with Trivy..."
        sh '''
          // trivy image --severity CRITICAL,HIGH --exit-code 1 -f json -o trivy-report.json $IMAGE_NAME || true
          trivy image --severity CRITICAL,HIGH -f table $IMAGE_NAME || true
          if grep -q '"Severity": "CRITICAL"' trivy-report.json; then
            echo "❌ Trivy found CRITICAL issues. Failing build."
            exit 1
          fi
        '''
      }
    }

    stage('Push to Docker Hub') {
      steps {
        echo "📤 Pushing image to Docker Hub..."
        withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push $IMAGE_NAME
          '''
        }
      }
    }
  }

  post {
    always {
      echo "📦 Archiving reports..."
      archiveArtifacts artifacts: '**/*.json', allowEmptyArchive: true
    }
    success {
      echo "✅ Build and security checks passed!"
    }
    failure {
      echo "❌ Pipeline failed due to one or more security issues."
    }
  }
}
