import peewee
from peewee import *
from peewee import PrimaryKeyField, ForeignKeyField, DateTimeField, TextField, CharField, IntegerField, FloatField, BooleanField

db_proxy = peewee.Proxy()


class BaseModel(peewee.Model):
    class Meta:
        database = db_proxy
        only_save_dirty = True


class Model_Types(BaseModel):
    ID = CharField(primary_key=True)
    Name = TextField()


class Publications(BaseModel):
    Publication_ID = PrimaryKeyField()
    Pubmed_Ref = TextField()
    Year = IntegerField()
    Full_Title = TextField()
    Temperature = FloatField()


class People(BaseModel):
    Person_ID = PrimaryKeyField()
    Person_First_Name = TextField()
    Person_Middle_Name = TextField()
    Person_Last_Name = TextField()
    Institution = TextField()
    Email = TextField()


class Publication_Authors(BaseModel):
    Publication = ForeignKeyField(Publications, field='Publication_ID', backref="Authors")
    Author = ForeignKeyField(People, field='Person_ID', backref="Publications")
    Author_Sequence = IntegerField()

    class Meta:
        primary_key = peewee.CompositeKey('Publication', 'Author')


class Models(BaseModel):
    Model_ID = CharField(primary_key=True)
    Equations = IntegerField()
    Runtime_Per_Step = FloatField()
    Max_Stable_DT = FloatField()
    Max_Stable_DT_Error = FloatField()
    Optimal_DT = FloatField()
    Optimal_DT_Error = FloatField()
    Optimal_DT_a = FloatField()
    Optimal_DT_b = FloatField()
    Optimal_DT_c = FloatField()
    CVODE_baseline_step_frequency = FloatField()
    CVODE_steps_per_spike = FloatField()
    Type = ForeignKeyField(Model_Types, field="ID", column_name="Type")
    Name = TextField()
    Publication = ForeignKeyField(Publications, field="Publication_ID", backref='Models')
    Directory_Path = TextField()
    File_Name = TextField()
    File_MD5_Checksum = TextField()
    File_Updated = DateTimeField()
    File = TextField()
    Status = TextField()
    Status_Timestamp = DateTimeField()
    Errors = TextField()
    Notes = TextField()
    ID_Helper = IntegerField()


class Model_Model_Associations(BaseModel):
    Parent = ForeignKeyField(Models, field='Model_ID', backref="Children")
    Child = ForeignKeyField(Models, field='Model_ID', backref="Parents")

    class Meta:
        primary_key = peewee.CompositeKey('Parent', 'Child')


class Model_Model_Association_Types(BaseModel):
    Parent_Type = ForeignKeyField(Model_Types, field='ID', column_name="Parent_Type")
    Child_Type = ForeignKeyField(Model_Types, field='ID', column_name="Child_Type")

    class Meta:
        primary_key = peewee.CompositeKey('Parent_Type', 'Child_Type')


class Channel_Class_Protocols(BaseModel):
    ID = PrimaryKeyField()
    Times = CharField()
    Voltages = CharField()
    Low_Voltage = FloatField()
    High_Voltage = FloatField()


class Channel_Classes(BaseModel):
    ID = TextField(primary_key=True)
    Name = TextField()
    Activation_Protocol = ForeignKeyField(Channel_Class_Protocols, column_name="Activation_Protocol_ID")
    Inactivation_Protocol = ForeignKeyField(Channel_Class_Protocols, column_name="Inactivation_Protocol_ID")
    Deactivation_Protocol = ForeignKeyField(Channel_Class_Protocols, column_name="Deactivation_Protocol_ID")
    Species = CharField()
    Reversal_Potential = FloatField()
    Ca_Levels = CharField()

class Channels(BaseModel):
    Model_ID = CharField(primary_key=True)
    Type = ForeignKeyField(Channel_Classes, field="ID", column_name="Channel_Type")
    Stability_Range_Low = FloatField()
    Stability_Range_High = FloatField()
    Time_Step = FloatField()

class Cells(BaseModel):
    Model_ID = CharField(primary_key=True)
    Sections = IntegerField()
    Compartments = IntegerField()
    Stability_Range_Low = FloatField()
    Stability_Range_High = FloatField()
    Is_Intrinsically_Spiking = BooleanField()
    Is_Passive = BooleanField()
    Rheobase_Low = FloatField()
    Rheobase_High = FloatField()
    Resting_Voltage = FloatField()
    Threshold_Current_Low = FloatField()
    Threshold_Current_High = FloatField()
    Bias_Voltage = FloatField()
    Bias_Current = FloatField()
    CVODE_Active = BooleanField()
    Threshold = FloatField()
    Is_GLIF = BooleanField()


class Morphometrics(BaseModel):
    ID = CharField(primary_key=True)
    Function_ID = IntegerField()


class Cell_Morphometrics(BaseModel):
    ID = PrimaryKeyField()
    Cell = ForeignKeyField(Cells, field='Model_ID')
    Metric = ForeignKeyField(Morphometrics, field='ID')
    Total = FloatField()
    Compartments_Considered = IntegerField()
    Compartments_Discarded = IntegerField()
    Minimum = FloatField()
    Average = FloatField()
    Maximum = FloatField()
    StDev = FloatField()


class Protocols(BaseModel):
    ID = CharField(primary_key=True)
    Description = TextField()


class Model_Waveforms(BaseModel):
    ID = PrimaryKeyField()
    Model = ForeignKeyField(Models, field='Model_ID', backref="Waveforms")
    Protocol = ForeignKeyField(Protocols, backref="Waveforms")
    Meta_Protocol = ForeignKeyField(Protocols)
    Waveform_Label = TextField()
    Time_Start = FloatField()
    Time_End = FloatField()
    Run_Time = FloatField()
    Variable_Name = TextField()
    Units = TextField()
    Timestamp = DateTimeField()
    Spikes = IntegerField()
    Min = FloatField()
    Max = FloatField()
    Mean = FloatField()
    STD = FloatField()
    Percent_Error = FloatField()
    Steps = IntegerField()
    dt_or_atol = FloatField()
    CVODE_active = BooleanField()


class Model_Translators(BaseModel):
    Model = ForeignKeyField(Models, field='Model_ID', backref="Translators")
    Translator = ForeignKeyField(People, field='Person_ID', backref="Translations")
    Translator_Sequence = IntegerField()

    class Meta:
        primary_key = peewee.CompositeKey('Model', 'Translator')


class Neurolexes(BaseModel):
    NeuroLex_ID = PrimaryKeyField()
    NeuroLex_URI = TextField()
    NeuroLex_Term = TextField()


class Model_Neurolexes(BaseModel):
    Model = ForeignKeyField(Models, field='Model_ID', backref="Neurolexes")
    Neurolex = ForeignKeyField(Neurolexes, field='NeuroLex_ID', backref="Models")

    class Meta:
        primary_key = peewee.CompositeKey('Model', 'Neurolex')


class Resources(BaseModel):
    Resource_ID = PrimaryKeyField()
    Name = TextField()
    LogoUrl = TextField()
    HomePageUrl = TextField()
    Identifying_URL_Snippet = TextField()
    SciCrunch_RRID = TextField()


class Refers(BaseModel):
    Reference_ID = PrimaryKeyField()
    Resource = ForeignKeyField(Resources, field='Resource_ID', backref="Resources", column_name='Reference_Resource_ID')
    Reference_URI = TextField()


class Model_References(BaseModel):
    Model = ForeignKeyField(Models, field='Model_ID', backref="References")
    Reference = ForeignKeyField(Refers, field='Reference_ID', backref="Models")

    class Meta:
        primary_key = peewee.CompositeKey('Model', 'Reference')


class Other_Keywords(BaseModel):
    Other_Keyword_ID = PrimaryKeyField()
    Other_Keyword_Term = TextField()


class Model_Other_Keywords(BaseModel):
    Model = ForeignKeyField(Models, field='Model_ID', backref="Keywords")
    Other_Keyword = ForeignKeyField(Other_Keywords, field='Other_Keyword_ID', backref="Models")

    class Meta:
        primary_key = peewee.CompositeKey('Model', 'Other_Keyword')



