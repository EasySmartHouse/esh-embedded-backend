package net.easysmarthouse.service.repository.impl;

import net.easysmarthouse.service.repository.VerificationTokenRepository;
import net.easysmarthouse.shared.domain.user.VerificationToken;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

@Repository
public class VerificationTokenRepositoryImpl implements VerificationTokenRepository {

    private Logger logger = Logger.getLogger(VerificationTokenRepositoryImpl.class);

    private class VerificationTokenMapper implements RowMapper<VerificationToken> {
        @Override
        public VerificationToken mapRow(ResultSet rs, int rowNum) throws SQLException {
            VerificationToken token = new VerificationToken();
            token.setId(rs.getLong("ID"));
            token.setToken(rs.getString("TOKEN"));
            token.setExpiryDate(rs.getDate("EXPIRY_DATE"));
            token.setUserId(rs.getLong("USER_ID"));
            return token;
        }
    }

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public VerificationToken save(VerificationToken verificationToken) {
        long tokenId = jdbcTemplate.update("INSERT INTO VERIFICATION_TOKEN (ID, TOKEN, EXPIRY_DATE, USER_ID) VALUES(?, ?, ?, ?)",
                new Object[]{verificationToken.getId(),
                        verificationToken.getToken(),
                        verificationToken.getExpiryDate(),
                        verificationToken.getId()}
        );
        verificationToken.setId(tokenId);
        return verificationToken;
    }

    @Override
    @Transactional(readOnly = true)
    public VerificationToken getToken(String token) {
        try {
            return jdbcTemplate.queryForObject("SELECT * FROM VERIFICATION_TOKEN WHERE TOKEN=?",
                    new Object[]{token},
                    new VerificationTokenMapper());
        } catch (EmptyResultDataAccessException ex) {
            return null;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public VerificationToken update(VerificationToken verificationToken) {
        try {
            jdbcTemplate.update("UPDATE VERIFICATION_TOKEN SET (TOKEN, EXPIRY_DATE) = (?, ?) WHERE ID = ? ",
                    new Object[]{verificationToken.getToken(), verificationToken.getExpiryDate()}
            );
            return verificationToken;
        } catch (Exception ex) {
            logger.error("Couldn't update token", ex);
            return null;
        }
    }

    @Override
    @Transactional
    public void deleteExpiredSince(Date date) {
        jdbcTemplate.update("DELETE FROM VERIFICATION_TOKEN WHERE EXPIRY_DATE <= ?",
                new Object[]{date});
    }
}
