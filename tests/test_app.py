import os
import sys
import pytest

# Enable testing mode BEFORE importing the app
os.environ["TESTING"] = "true"

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "app")))

from app import app, db, User


@pytest.fixture
def client():

    app.config["TESTING"] = True
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///:memory:"

    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client


def test_health_endpoint(client):
    response = client.get("/health")
    assert response.status_code == 200


def test_add_user(client):
    response = client.post("/", data={"name": "testuser"}, follow_redirects=True)
    assert response.status_code == 200


def test_database_insert(client):
    with app.app_context():
        user = User(name="pytest-user")
        db.session.add(user)
        db.session.commit()

        result = User.query.filter_by(name="pytest-user").first()
        assert result is not None
