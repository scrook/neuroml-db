TRUNCATE TABLE batch_task_queue;

INSERT INTO batch_task_queue (Command)
SELECT CONCAT('python manage.py save_model_properties ', Model_ID, ' spike_counts') FROM neuromldb.models
WHERE Type in ('CL')
;

# All tasks
SELECT * FROM neuromldb.batch_task_queue;

# Remaining tasks
SELECT * FROM neuromldb.batch_task_queue WHERE Status = 0;


#call get_next_task();


#call finish_task(5);

#Pause
UPDATE batch_task_queue SET Status = 4 WHERE Status = 0

#Resume
UPDATE batch_task_queue SET Status = 0 WHERE Status = 4

# Reset
UPDATE batch_task_queue SET Status = 0

UPDATE batch_task_queue SET Command = REPLACE(Command, "spike_counts", "wave_stats")