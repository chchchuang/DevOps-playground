from fastapi.testclient import TestClient

from main import app

client = TestClient(app)

def test_home():
    response = client.get("/")
    assert response.status_code == 200
    assert "Hello world!" in response.text
    print("test_home OK")

if __name__ == "__main__":
    test_home()