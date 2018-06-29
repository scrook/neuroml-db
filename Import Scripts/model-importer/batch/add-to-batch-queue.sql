TRUNCATE TABLE batch_task_queue;

INSERT INTO batch_task_queue (Command)
SELECT CONCAT('python manage.py save_model_properties ', Model_ID, ' ALL') FROM neuromldb.models
WHERE Type in ('CL', 'CH') AND (Status_Timestamp is null OR Status_Timestamp < '2018-06-27 19:31:00')
;