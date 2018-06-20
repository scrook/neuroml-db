from nmldbmodel import NMLDB_Model


class ChannelModel(NMLDB_Model):
    def __init__(self, *args, **kwargs):
        super(ChannelModel, self).__init__(*args, **kwargs)

        self.all_properties.extend([
            'tolerances',
            'stability_range',
            'DT_SENSITIVITY',
        ])