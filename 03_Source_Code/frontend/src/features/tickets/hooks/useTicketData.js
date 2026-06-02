import { useState, useEffect } from 'react';
import { bookingService } from '../../bookings/services/bookingService';
import { facilityService } from '../../facilities/services/facilityService';

export const useTicketData = (bookingId) => {
  const [booking, setBooking] = useState(null);
  const [facility, setFacility] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    let isMounted = true;

    const fetchTicketData = async () => {
      try {
        setIsLoading(true);
        setError(null);

        // Fetch Booking
        const bookingRes = await bookingService.getBookingById(bookingId);
        // Accommodate API returning { success: true, data: {...} } OR just the object
        if (!bookingRes.success && !bookingRes.id) {
          throw new Error('Gagal memuat data tiket.');
        }
        
        const bookingData = bookingRes.data?.booking || bookingRes.data || bookingRes;
        
        // Fetch digital signature permit if booking is approved or checked_in
        const statusLower = bookingData.status?.toLowerCase();
        if (statusLower === 'approved' || statusLower === 'checked-in' || statusLower === 'checked_in') {
          try {
            const permitRes = await bookingService.getBookingPermit(bookingId);
            const permitData = permitRes.data || permitRes;
            if (permitData?.digital_signature) {
              bookingData.digital_signature = permitData.digital_signature;
            }
          } catch (permitErr) {
            console.error('Gagal memuat digital signature permit:', permitErr);
          }
        }
        
        if (isMounted) setBooking(bookingData);

        // Fetch Facility
        if (bookingData.facility_id) {
          const facilityRes = await facilityService.getFacilityById(bookingData.facility_id);
          const facilityData = facilityRes.data?.facility || facilityRes.data || facilityRes;
          if (isMounted) setFacility(facilityData);
        }
      } catch (err) {
        if (isMounted) setError(err.message || 'Terjadi kesalahan saat memuat tiket.');
      } finally {
        if (isMounted) setIsLoading(false);
      }
    };

    if (bookingId) {
      fetchTicketData();
    }

    return () => {
      isMounted = false;
    };
  }, [bookingId]);

  return { booking, facility, isLoading, error, setBooking };
};
