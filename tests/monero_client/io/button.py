import requests


class FakeButton:
    def right_click(self):
        pass

    def left_click(self):
        pass

    def both_click(self):
        pass

class Button:
    def __init__(self, server: str, port: int) -> None:
        self.server = server
        self.port = port
        self.button_url = f'http://{self.server}:{self.port}/button/'
        self.click_data = {"action": "press-and-release"}

    def right_click(self):
        response = requests.post(self.button_url + "right", json=self.click_data)

        if response.status_code != 200:
            raise Exception(f"Button Request failed with status code {response.status_code}")

    def left_click(self):
        response = requests.post(self.button_url + "left", json=self.click_data)

        if response.status_code != 200:
            raise Exception(f"Button Request failed with status code {response.status_code}")

    def both_click(self):
        response = requests.post(self.button_url + "both", json=self.click_data)

        if response.status_code != 200:
            raise Exception(f"Button Request failed with status code {response.status_code}")
