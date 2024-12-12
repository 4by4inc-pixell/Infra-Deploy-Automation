import ray
import time

ray.init("ray://ray.us-west-2.aipixell.com:10001")


@ray.remote(num_cpus=1, num_gpus=0)
class TestCPUActor:
    def __init__(self, id):
        self.id = id

    def run(self):
        print(f"My id is {self.id}")
        time.sleep(1)
        return self.id


@ray.remote(num_cpus=1, num_gpus=1)
class TestGPUActor:
    def __init__(self, id):
        self.id = id

    def run(self):
        print(f"My id is {self.id}")
        time.sleep(1)
        return self.id


actors = [
    # TestCPUActor.remote(i)
    TestGPUActor.remote(i)
    for i in range(20)
    # TestCPUActor.remote(0),
    # TestGPUActor.remote(1),
]

while True:
    ray.get([a.run.remote() for a in actors])

match actors:
    case [cpu1, gpu1]:
        print(f"CPU actor: {cpu1}, GPU actor: {gpu1}")
    case [cpu1, *rest]:
        print(f"CPU actor: {cpu1}, remaining actors: {rest}")
    case [*rest, gpu1]:
        print(f"Remaining actors: {rest}, GPU actor: {gpu1}")
    case []:
        print("No more actors")
