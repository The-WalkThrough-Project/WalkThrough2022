String horarioAtoF(String horario){
  switch (horario) {
    case '1M2M':
      return '07:00.08:40';
    case '3M4M':
      return '08:55.10:35';
    case '5M6M':
      return '10:50.12:30';
    case '1T2T':
      return '13:50.15:30';
    case '3T4T':
      return '15:50.17:30';
    case '4T5T':
      return '16:40.18:20';
    case '1N2N':
      return '19:00.20:40';
    case '3N4N':
      return '20:55.22:35';
    default: 
      return '';
  }
}