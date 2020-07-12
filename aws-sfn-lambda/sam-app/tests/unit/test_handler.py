import pytest

from src import app


@pytest.fixture()
def sfn_event():
    """ Generates SFN Event"""

    return {
        "command": "run_query",
        "args": {
            "query": "SELECT * FROM PERSON"
        }
    }



def test_lambda_handler(sfn_event, mocker):

    ret = app.lambda_handler(sfn_event, "")

    assert ret["status"] == "success"
    assert ret["result"] == '[[1, "Axel"], [2, "Mr. Foo"], [3, "Ms. Bar"]]'
