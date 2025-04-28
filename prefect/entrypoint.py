import os

commands = [
    f"prefect worker start",
    f"--pool {os.environ['PREFECT_WORK_POOL_NAME']}",
    f"--name {os.environ['PREFECT_WORKER_NAME']}",
    f"--install-policy always",
    f"--with-healthcheck",
    *[f"--work-queue '{q}'" for q in os.environ["PREFECT_WORK_QUEUES"].split(",")],
]
com = " ".join(commands)
os.system(com)
