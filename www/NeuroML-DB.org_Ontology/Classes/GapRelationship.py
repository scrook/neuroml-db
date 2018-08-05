from Classes.Relationship import Relationship


class GapRelationship():
    def __init__(self, end1, relationship1, gap, relationship2, end2):

        self.Relationship1 = Relationship(end1, relationship1, gap)
        self.Relationship2 = Relationship(gap, relationship2, end2)

        self.Gap = gap