from DumpLift import DumpLift, get_l2r_l4


def print_angles(l2, angs: list[float]):
    ang_labels = ["θ2", "θ3", "θ4", "θ5"]
    print(f"l2:{l2:6.2f} cm\tAngles (deg):", end="\t")
    for i, ang in enumerate(angs):
        print(f"{ang_labels[i]}: {ang:.2f}", end="\t")
    print(f"Output Angle: {(180 - angs[3]):.2f} deg")
    print()


if __name__ == '__main__':
    tilt_angle = 5
    l3, l5, f = 100, 200, 0.2  # cm
    l1 = l5
    l2r, l4, l4a, l4b = get_l2r_l4(l3, l5, tilt_angle, f)
    print(l2r, l4, l4a, l4b)
    l2_min = round(l2r) + 1
    l2_max = round(l3+l4b) - 1

    for l2 in range(l2_min, l2_max):
        position = DumpLift(l1, l2, l3, l4a, l4b, l5)
        print_angles(l2, position.angles_deg())
