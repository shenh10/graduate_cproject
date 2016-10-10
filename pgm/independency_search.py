"""
Sample input:
A	B	C	D	unnormalized_P
0	0	0	0	360000
0	0	0	1	600
0	0	1	0	36000
0	0	1	1	3600
0	1	0	0	600
0	1	0	1	100000
0	1	1	0	60
0	1	1	1	600000
1	0	0	0	6000
1	0	0	1	10
1	0	1	0	900
1	0	1	1	90
1	1	0	0	600
1	1	0	1	100000
1	1	1	0	90
1	1	1	1	900000


"""
import itertools as it
DEBUG = 0
def LOG(debug_level, *args):
    if debug_level > 0:
        for l in xrange(len(args)):
            print args[l]

def read_file(filename):
    with open(filename, 'r') as fd:
        lines = fd.readlines()
        _dict = {}
        keys = []
        for i, line in enumerate(lines):
            if i == 0:
                for key in line.split():
                    _dict[key] = []
                    keys.append(key)
                P_tag = keys[-1]
            else:
                for j, key in enumerate(line.split()):
                    _dict[keys[j]].append(float(key))
        return _dict, P_tag

def print_table(keys, ids, _sub_):
    LOG( DEBUG,  'P(%s)'%(','.join([keys[_id] for _id in ids] )))
    LOG( DEBUG,  '    '.join([keys[_id] for _id in ids] ))
    for com in _sub_.keys():
        LOG( DEBUG, '%s    %s'%('    '.join([ str(l) for l in com]), _sub_[com]))

def solve(_dict, P_tag):
    """
    Compute all joint probabilities of listed variables
    eg.
    A, B, C, D
    compute
    P(A, B, C, D)
    P(A, B, C), P(A, B, D), P(A, C, D), P(B, C, D)
    P(A, B), P(A, C), P(A, D), P(B, C), P(B, D), P(C, D)
    P(A), P(B), P(C), P(D)
    """
    keys = _dict.keys()
    keys.sort()
    keys.remove(P_tag)
    num_var = len(keys)
    joint = {}
    for i in reversed(xrange(0, num_var)):
        #LOG( DEBUG, '#####################################')
        combis = it.combinations(range(num_var), i + 1)
        for com in combis:
            _sub_ = {}
            _sum = 0
            for index  in xrange(len(_dict[P_tag])):
                new_keys = tuple([ (int(_dict[keys[var]][index])) for var in com])
                if new_keys not in _sub_.keys():
                    _sub_[new_keys] = _dict[P_tag][index]
                else:
                    _sub_[new_keys] += _dict[P_tag][index]
                _sum += _dict[P_tag][index]
            for index in _sub_.keys():
                _sub_[index] /= _sum
            joint[com] = _sub_
            print_table(keys, list(com), _sub_)
    return keys, joint
def parse_to_string(keys, lt):
    return ','.join([ keys[l] for l in lt])

def find_independency(keys, joint, eps = 0.0000001):
    """
    Compute all (conditional) indepencies
    """
    num_var = len(keys)
    # search for independency
    
    for i in xrange(1,num_var):
        varv = it.combinations(range(num_var), i+1)
        for var in varv:
            # joint distribution, eg. P(A, B)
            joint_v = sorted( var )
            table_v = joint[tuple(joint_v)]
            # divide var to 2 parts, eg. P(A ) P (B )
            for k in xrange(max(int((len(var)+1)/2), len(var) -1 )):
                flag = 0
                vv_all = it.combinations(range(len(var)), k + 1)
                for vv in vv_all:
                    part1 = [ var[xv] for xv in vv ]
                    part2 = list( set(var) - set(part1))
                    part1n = tuple(sorted(part1))
                    part2n = tuple(sorted(part2))
                    part1n_id = [joint_v.index(xv) for xv in part1n ]
                    part2n_id = [joint_v.index(xv) for xv in part2n ]
                    LOG(DEBUG, 'Testing P(%s) with ( P(%s), P(%s))'%( parse_to_string(keys, var) , parse_to_string(keys, part1), parse_to_string(keys, part2)) )
                    for key in table_v.keys():
                        cond = table_v[key] 
                        cond_p1 =  joint[part1n][tuple([key[d] for d in part1n_id])] 
                        cond_p2 = joint[part2n][tuple([key[d] for d in part2n_id])] 
                        LOG( DEBUG, '%f, %f'%(cond, cond_p2* cond_p1))
                        if abs(cond_p1 * cond_p2 - cond ) > eps:
                            flag = 1
                            break
                    if flag == 1:
                        break
                    else:
                        print 'P(%s) = P(%s) * P(%s)'%( parse_to_string(keys, var) , parse_to_string(keys, part1), parse_to_string(keys, part2)) 


    # search for conditional independency
    for i in xrange(1, num_var):
        varv = it.combinations(range(num_var), i+1)
        for var in varv:
            var = list(var)
            evv = list(set(xrange(num_var)) - set(var))
            for j in xrange(1, len(evv)+1):
                evidence = it.combinations(range(len(evv)), j )
                for ev in evidence:
                    # P (v | ev), eg. P(A, B | C)
                    joint_v_ev = sorted( [ evv[xv] for xv in ev] + var )
                    joint_ev = sorted([ evv[xv] for xv in ev] )
                    table_ev = joint[tuple(joint_ev)]
                    table_v_ev = joint[tuple(joint_v_ev)]
                    ids = [joint_v_ev.index(xv) for xv in joint_ev ]
                    # divide v to 2 parts, eg. P(A | C) P (B | C)
                    for k in xrange(max(int((len(var)+1)/2), len(var) -1 )):
                        flag = 0
                        vv_all = it.combinations(range(len(var)), k + 1)
                        for vv in vv_all:
                            part1 = [ var[xv] for xv in vv ]
                            part2 = list( set(var) - set(part1))
                            part1n = tuple(sorted(part1 + [ evv[xv] for xv in ev] ))
                            part2n = tuple(sorted(part2 + [ evv[xv] for xv in ev]))
                            part1n_id = [joint_v_ev.index(xv) for xv in part1n ]
                            part2n_id = [joint_v_ev.index(xv) for xv in part2n ]
                            LOG(DEBUG, 'Testing P(%s|%s) with ( P(%s|%s), P(%s|%s))'%( parse_to_string(keys, var) , parse_to_string(keys, [ evv[xv] for xv in ev] ), parse_to_string(keys, part1), parse_to_string(keys, [ evv[xv] for xv in ev] ), parse_to_string(keys, part2), parse_to_string(keys, [ evv[xv] for xv in ev] )) )
                            for key in table_v_ev.keys():

                                prob_ev = table_ev[tuple([key[d] for d in ids])]  
                                cond = table_v_ev[key] / prob_ev
                                cond_p1 =  joint[part1n][tuple([key[d] for d in part1n_id])] / prob_ev 
                                cond_p2 = joint[part2n][tuple([key[d] for d in part2n_id])] / prob_ev 
                                LOG( DEBUG, '%f, %f'%(cond, cond_p2* cond_p1))
                                if abs(cond_p1 * cond_p2 - cond ) > eps:
                                    flag = 1
                                    break
                            if flag == 1:
                                break
                            else:
                                print 'P(%s | %s ) = P(%s | %s) * P(%s| %s)'%( parse_to_string(keys, var) , parse_to_string(keys, [ evv[xv] for xv in ev] ), parse_to_string(keys, part1), parse_to_string(keys, [ evv[xv] for xv in ev] ), parse_to_string(keys, part2), parse_to_string(keys, [ evv[xv] for xv in ev] )) 



if __name__ == '__main__':
    table_name = '4-table2.txt'
    _dict, P_tag = read_file(table_name)
    keys, joint = solve(_dict, P_tag)
    #LOG( DEBUG, "##########################")
    find_independency(keys, joint)
