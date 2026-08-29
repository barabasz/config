import logging
from pyspark.logger import PySparkLogger

PySparkLogger.getLogger("SQLQueryContextLogger").setLevel(logging.CRITICAL)
PySparkLogger.getLogger("DataFrameQueryContextLogger").setLevel(logging.CRITICAL)

sc.setLogLevel("ERROR")