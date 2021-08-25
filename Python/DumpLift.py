from math import acos, cos, sqrt, pi


def x(a, b, c):
    return (a ** 2 + b ** 2 - c ** 2) / (2 * a * b)


def trig_angle(a, b, c):
    return acos((a ** 2 + b ** 2 - c ** 2) / (2 * a * b))


def trig_arm(a, b, C):
    return sqrt(a ** 2 + b ** 2 - 2 * a * b * cos(C))


def rad_to_deg(x):
    return (180 * x) / pi


class DumpLift:
    def __init__(self, l1, l2, l3, l4, l5, f):
        self.l1 = l1
        self.l2 = l2
        self.l3 = l3
        self.l4 = l4
        self.l5 = l5
        self.f = f

        # intermediate vars
        self._a43 = trig_angle(self.l3, (self.f * self.l4), self.l2)
        self._l7 = trig_arm(self.l3, self.l4, self._a43)
        self._a51 = trig_angle(self.l1, self.l5, self._l7)
        self._a57 = trig_angle(self.l5, self._l7, self.l1)
        self._a47 = trig_angle(self.l4, self._l7, self.l3)
        self._a54 = self._a57 - self._a47
        self._l8 = trig_arm(self.l5, self.l4, self._a54)
        self._a23 = trig_angle(self.l2, self.l3, (self.f * self.l4))

        # calculate angles in radians
        self.a3 = trig_angle(self.l1, self.l3, self._l8)
        self.a2 = self._a23 + self.a3
        self.a4 = (pi - self._a43) + self.a3
        self.a5 = pi - self._a51

    def a2_rad(self):
        return self.a2

    def a3_rad(self):
        return self.a3

    def a4_rad(self):
        return self.a4

    def a5_rad(self):
        return self.a5

    def a2_deg(self):
        return rad_to_deg(self.a2)

    def a3_deg(self):
        return rad_to_deg(self.a3)

    def a4_deg(self):
        return rad_to_deg(self.a4)

    def a5_deg(self):
        return rad_to_deg(self.a5)

    def angles_rad(self):
        return [self.a2, self.a3, self.a4, self.a5]

    def angles_deg(self):
        result = []
        rad_list = self.angles_rad()
        for ran_ang in rad_list:
            result.append(rad_to_deg(ran_ang))

        return result


if __name__ == '__main__':
    print(x(0.7, (0.3 * 0.5), 0.6))
    print(trig_angle(0.7, (0.3 * 0.5), 0.6))
