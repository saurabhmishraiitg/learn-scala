import unittest

# from datetime import datetime, timedelta
# from tempfile import NamedTemporaryFile
# from unittest import mock
from plugins.operators.CustomDProcClusterCreateOperator import CustomDProcClusterCreateOperator

# import pytest
# from parameterized import parameterized

# from airflow.exceptions import AirflowException, AirflowSkipException
# from airflow.models import DagRun
# from airflow.models.dag import DAG
# from airflow.operators.bash import BashOperator
# from airflow.utils import timezone
# from airflow.utils.state import State
# from airflow.utils.types import DagRunType

# DEFAULT_DATE = datetime(2016, 1, 1, tzinfo=timezone.utc)
# END_DATE = datetime(2016, 1, 2, tzinfo=timezone.utc)
# INTERVAL = timedelta(hours=12)


class TestCustomDProcClusterCreateOperator(unittest.TestCase):
    def test_init(self):
        createOperator = CustomDProcClusterCreateOperator(
            task_id="test-task", product_line="test-prod", app_name="test-app"
        )


#     def test_echo_env_variables(self):
#         """
#         Test that env variables are exported correctly to the task bash environment.
#         """
#         utc_now = datetime.utcnow().replace(tzinfo=timezone.utc)
#         dag = DAG(
#             dag_id='bash_op_test',
#             default_args={'owner': 'airflow', 'retries': 100, 'start_date': DEFAULT_DATE},
#             schedule_interval='@daily',
#             dagrun_timeout=timedelta(minutes=60),
#         )

#         dag.create_dagrun(
#             run_type=DagRunType.MANUAL,
#             execution_date=utc_now,
#             start_date=utc_now,
#             state=State.RUNNING,
#             external_trigger=False,
#         )

#         with NamedTemporaryFile() as tmp_file:
#             task = BashOperator(
#                 task_id='echo_env_vars',
#                 dag=dag,
#                 bash_command='echo $AIRFLOW_HOME>> {0};'
#                 'echo $PYTHONPATH>> {0};'
#                 'echo $AIRFLOW_CTX_DAG_ID >> {0};'
#                 'echo $AIRFLOW_CTX_TASK_ID>> {0};'
#                 'echo $AIRFLOW_CTX_EXECUTION_DATE>> {0};'
#                 'echo $AIRFLOW_CTX_DAG_RUN_ID>> {0};'.format(tmp_file.name),
#             )

#             with mock.patch.dict(
#                 'os.environ', {'AIRFLOW_HOME': 'MY_PATH_TO_AIRFLOW_HOME', 'PYTHONPATH': 'AWESOME_PYTHONPATH'}
#             ):
#                 task.run(utc_now, utc_now, ignore_first_depends_on_past=True, ignore_ti_state=True)

#             with open(tmp_file.name) as file:
#                 output = ''.join(file.readlines())
#                 assert 'MY_PATH_TO_AIRFLOW_HOME' in output
#                 # exported in run-tests as part of PYTHONPATH
#                 assert 'AWESOME_PYTHONPATH' in output
#                 assert 'bash_op_test' in output
#                 assert 'echo_env_vars' in output
#                 assert utc_now.isoformat() in output
#                 assert DagRun.generate_run_id(DagRunType.MANUAL, utc_now) in output

#     @parameterized.expand(
#         [
#             ('test-val', 'test-val'),
#             ('test-val\ntest-val\n', ''),
#             ('test-val\ntest-val', 'test-val'),
#             ('', ''),
#         ]
#     )

if __name__ == "__main__":
    unittest.main()
