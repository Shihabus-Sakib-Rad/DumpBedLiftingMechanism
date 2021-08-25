from DumpLift import DumpLift


def print_angles(l2, angs: list[float]):
    links = ["l2", "l3", "l4", "l5"]
    ang_labels = ["θ2", "θ3", "θ4", "θ5"]
    print(f"l2:{l2:6.2f} cm\tAngles (deg):", end="\t")
    for i, ang in enumerate(angs):
        print(f"{ang_labels[i]}: {ang:.2f}", end="\t")
    # print(f"Output Angle: {(180 - angs[3]):.2f} deg")
    print()


if __name__ == '__main__':
    l1, l2, l3, l4, l5, f = 200, 120, 104, 120, 200, 0.2  # cm

    l2_min: float = l3 - f * l4
    l2_max: float = l3 + f * l4
    for l2 in range(round(l2_min + 1), round(l2_max - 1)):
        position = DumpLift(l1, l2, l3, l4, l5, f)
        print_angles(l2, position.angles_deg())
