# import googleapiclient
# import re
# import uuid
# from datetime import timedelta

# from airflow.contrib.hooks.gcp_dataproc_hook import DataProcHook

# from plugins.operators.GCSBucketUtil import GCSBucketUtil
# from plugins.operators.CommonUtil import CommonUtil
# from airflow.exceptions import AirflowException
# from airflow.models import BaseOperator
# from airflow.utils.decorators import apply_defaults
# from airflow.version import version
# from airflow.utils import timezone


"""
Custom BigQuerySQLOperator implementation to sync with GG ETL workflows
# TODO Incorporate Jinja Tempalating for relevant attributes
"""
# class BigQuerySQLOperator(BaseOperator):