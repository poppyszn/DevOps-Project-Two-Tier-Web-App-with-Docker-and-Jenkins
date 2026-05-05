pipeline{
    agent any
    stages{
        stage('Clone repo'){
            steps{
                git branch: 'main', url: 'https://github.com/poppyszn/DevOps-Project-Two-Tier-Web-App-with-Docker-and-Jenkins.git'
            }
        }
        stage('Build image'){
            steps{
                sh 'docker build -t flask-app .'
            }
        }
        stage('Lint'){
            steps{
                sh 'docker run --rm flask-app sh -c "pip install flake8 -q && flake8 app.py --max-line-length=120"'
            }
        }
        stage('Validate compose config'){
            steps{
                sh 'docker compose config -q'
            }
        }
        stage('Smoke test'){
            steps{
                sh 'docker run -d --name smoke-test -p 5001:5000 -e MYSQL_HOST=none -e MYSQL_USER=none -e MYSQL_PASSWORD=none -e MYSQL_DB=none flask-app'
                sh 'sleep 3'
                sh 'curl -sf http://localhost:5001 || curl -s -o /dev/null -w "%{http_code}" http://localhost:5001 | grep -qv 000'
            }
            post{
                always{
                    sh 'docker rm -f smoke-test || true'
                }
            }
        }
        stage('Deploy with docker compose'){
            steps{
                // existing container if they are running
                sh 'docker compose down || true'
                // start app, rebuilding flask image
                sh 'docker compose up -d --build'
            }
        }
        stage('Run migrations'){
            steps{
                // wait for mysql to pass its healthcheck before applying schema
                sh '''
                    echo "Waiting for MySQL to be healthy..."
                    for i in $(seq 1 30); do
                        STATUS=$(docker inspect --format="{{.State.Health.Status}}" mysql 2>/dev/null || echo "missing")
                        if [ "$STATUS" = "healthy" ]; then
                            echo "MySQL is healthy."
                            break
                        fi
                        echo "  attempt $i/30 - status: $STATUS"
                        sleep 3
                        if [ "$i" = "30" ]; then
                            echo "MySQL did not become healthy in time."
                            exit 1
                        fi
                    done
                '''
                sh 'docker exec -i mysql sh -c \'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" devops\' < message.sql'
            }
        }
    }
}