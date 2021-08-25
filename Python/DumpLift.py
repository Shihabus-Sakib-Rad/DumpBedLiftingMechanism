from math import acos, cos, sqrt, pi


def get_l2r_l4(l3, l5, x51, f):
    l4 = trig_arm(l5-l3, l5, x51)
    x41cw = trig_angle(l5-l3, l4, l5)
    x41ccw = 180 - x41cw
    l4b = f*l4
    l4a = l4 - l4b
    l2r = trig_arm(l3, l4b, x41ccw)
    return l2r, l4, l4a, l4b


def trig_angle(a, b, c):
    return rad_to_deg(acos((a ** 2 + b ** 2 - c ** 2) / (2 * a * b)))


def trig_arm(a, b, C):
    C = deg_to_rad(C)
    return sqrt(a ** 2 + b ** 2 - 2 * a * b * cos(C))


def rad_to_deg(x):
    return (180 * x) / pi


def deg_to_rad(x):
    return (pi * x) / 180


class DumpLift:
    def __init__(self, l1, l2, l3, l4a, l4b, l5):
        self.l1 = l1
        self.l2 = l2
        self.l3 = l3
        self.l4a = l4a
        self.l4b = l4b
        self.l5 = l5
        self.l4 = l4a + l4b

        # intermediate vars
        self._a43 = trig_angle(self.l3, self.l4b, self.l2)
        self._l7 = trig_arm(self.l3, self.l4, self._a43)
        self._a51 = trig_angle(self.l1, self.l5, self._l7)
        self._a57 = trig_angle(self.l5, self._l7, self.l1)
        self._a47 = trig_angle(self.l4, self._l7, self.l3)
        self._a54 = self._a57 - self._a47
        self._l8 = trig_arm(self.l5, self.l4, self._a54)
        self._a23 = trig_angle(self.l2, self.l3, self.l4b)

        # calculate angles in radians
        self.a3 = trig_angle(self.l1, self.l3, self._l8)
        self.a2 = self._a23 + self.a3
        self.a4 = (180 - self._a43) + self.a3
        self.a5 = 180 - self._a51

    def angles_deg(self):
        return [self.a2, self.a3, self.a4, self.a5]

    def print_all(self):
        r = [self._l7, self._l8]
        r2 = [self._a23, self._a43, self._a51, self._a54, self._a57, self._a47]
        for i in r:
            print(f"{i:.2f}")
        for i in r2:
            print(f"{i:.2f}")
        for i in self.angles_deg():
            print(f"{i:.2f}")
